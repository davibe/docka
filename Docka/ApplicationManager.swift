//
//  Manager.swift
//  Docka
//
//  Created by Davide Bertola on 21/11/2016.
//  Copyright © 2016 Davide Bertola. All rights reserved.
//

import Foundation
import Cocoa
import CoreFoundation
import Silica
import CoreGraphics

import StreamSwift
typealias Stream = StreamSwift.Stream


struct Win: Equatable {
    let key: String
    let debug: String
    let application: NSRunningApplication
    let siWindow: SIWindow
    
    func visible() -> Bool {
        
        guard let screen = siWindow.screen() else { return false }
        return NSScreen.screens.firstIndex(of: screen) == 0
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.key == rhs.key
    }
}

struct AppState: Equatable {
    var windows: [Win] = []
    var hiddenWindowKeys: [String] = []
    var rectCache: [String: CGRect] = [:]
    var windowLastFocused: SIWindow? = nil
}

protocol Action { }

struct WinTap: Action {
    let win: Win
}

struct WinTapSecondary: Action {
    let win: Win
}


class ApplicationManager {
    
    var stateStream = Stream<AppState>().trigger(AppState())
    
    private var state: AppState = AppState() {
        didSet { // this bridges shared mutable state to a reactive approach
            if (oldValue != state) {
                stateStream.trigger(state)
            }
        }
    }
    
    private var applicationLastObserver: Observer = Observer()
    
    func setup() {

        applicationLastObserver = Observer(
            nc: NSWorkspace.shared.notificationCenter,
            name: "NSWorkspaceDidActivateApplicationNotification",
            cb: { [weak self] (notification) in
                if
                    let userInfo = notification.userInfo,
                    let application = userInfo["NSWorkspaceApplicationKey"] as? NSRunningApplication
                    //application != NSRunningApplication.current
                {
                    self?.indexWindows()
                }
        }).on()
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] _ in self?.indexWindows() })
    }
    
    private func indexWindows() {
        guard let siWindows = SIWindow.allWindows() else { return }
        let windows = siWindows.compactMap { (window) -> Win? in
            guard
                let processIdentifier = window.app()?.processIdentifier(),
                let appTitle = window.app()?.title(),
                let windowTitle = window.title(),
                let pid = window.app()?.processIdentifier(),
                let nsapp = NSRunningApplication.init(processIdentifier: pid),
                // some exceptions
                !windowTitle.isEmpty, // <- android emulator ghost window
                windowTitle != "Microsoft Teams Notification"
                else { return nil }
            let windowId = window.windowID()
            
            let key = "\(processIdentifier):\(windowId)"
            let debug = "\(key):\(appTitle):\(windowTitle)"
            return Win(
                key: key,
                debug: debug,
                application: nsapp,
                siWindow: window
            )
        }.sorted(by: { (a, b) -> Bool in
            return a.key.compare(b.key).rawValue < 0
        }).compactMap({ $0 })
        
        state.windows = windows
        state.hiddenWindowKeys = windows.filter { ApplicationManager.isHidden(w: $0) }.map { $0.key }
        
        if let focusedWindow = SIWindow.focused() {
            state.windowLastFocused = focusedWindow
        }
    }
    
    func dispatch(action: Action) {
        switch action {
        case let tap as WinTap:
            let win = tap.win
            toggleHidden(win: win)
            break
        case let tap as WinTapSecondary:
            let win = tap.win
            if ApplicationManager.isHidden(w: win) {
                toggleHidden(win: win)
            }
            hideOthers(win: win)
            break
        default:
            break
        }
        indexWindows()
    }
    
    class func isHidden(w: Win) -> Bool {
        guard let screenFrame = NSScreen.screens.first?.frame else { return false }
        return screenFrame.width - 100 < w.siWindow.frame().origin.x
    }
    
    // utils
    
    private func hide(win: Win) {
        let windowFrame = win.siWindow.frame()
        state.rectCache[win.key] = windowFrame
        guard let screenFrame = NSScreen.screens.first?.frame else { return }
        win.siWindow.setPosition(CGPoint(x: screenFrame.width * 2, y: windowFrame.origin.y))
    }
    
    private func unhide(win: Win) {
        guard let screenFrame = win.siWindow.screen()?.frame else { return }
        let windowFrame = win.siWindow.frame()
        let rect = state.rectCache[win.key] ?? CGRect(
            origin: CGPoint(
                x: (screenFrame.size.width - windowFrame.size.width) / 2,
                y: (screenFrame.size.height - windowFrame.size.height) / 2
            ),
            size: windowFrame.size
        )
        state.rectCache.removeValue(forKey: win.key)
        win.siWindow.setFrame(rect)
        focus(win: win)
    }
    
    private func focus(win: Win) {
        // only bring forward this specific window
        AXUIElementSetAttributeValue(win.siWindow.axElementRef, NSAccessibility.Attribute.main as CFString, kCFBooleanTrue)
        win.application.activate(options: .activateIgnoringOtherApps)
    }
    
    private func toggleHidden(win: Win) {
        let focused = state.windowLastFocused == win.siWindow
        
        if ApplicationManager.isHidden(w: win) {
            unhide(win: win)
            return
        }
        
        if (!focused) {
            focus(win: win)
        } else {
            // hide
            hide(win: win)
        }
    }
    
    private func hideOthers(win: Win) {
        state.windows.forEach { (it) in
            if it == win { return }
            if !ApplicationManager.isHidden(w: it) {
                hide(win: it)
            }
        }
    }
    
}
