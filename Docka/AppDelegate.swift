//
//  AppDelegate.swift
//  Docka
//
//  Created by Davide Bertola on 19/11/2016.
//  Copyright © 2016 Davide Bertola. All rights reserved.
//

import Cocoa
import CoreVideo


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let applicationManager = ApplicationManager()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let app:NSApplication = NSApplication.shared
        app.setActivationPolicy(.accessory)
        
        let window:NSWindow = app.windows[0]
        window.isOpaque = true
        window.backgroundColor = NSColor.clear
        window.hasShadow = false
        window.canHide = false
        window.level = NSWindow.Level(rawValue: 1)
        window.isMovable = false
        window.isMovableByWindowBackground = false
        window.contentView?.wantsLayer = true
        
        if let layer = window.contentView?.layer {
            layer.cornerRadius = 1.0
            layer.borderWidth = 0
            layer.masksToBounds = true
            layer.backgroundColor = NSColor.white.withAlphaComponent(0.1).cgColor
        }
        
        if let screen:NSScreen = NSScreen.main {
            let size: CGSize = CGSize(width: window.frame.width, height: 30)
            let origin: CGPoint = CGPoint(x: screen.frame.origin.x, y: screen.frame.origin.x)
            let rect: CGRect = CGRect(origin: origin, size: size)
            
            window.setFrame(rect, display: true)
        }
        
        applicationManager.setup()
        let vc = window.contentViewController as! ViewController
        bindViewController(vc: vc, stream: applicationManager.stateStream, dispatch: applicationManager.dispatch(action:))
        
    }
    
}

