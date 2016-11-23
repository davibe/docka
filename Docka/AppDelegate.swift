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
    
    var workspaceObserver:Observer? = nil
    var refreshObserver:Observer? = nil
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let app:NSApplication = NSApplication.shared()
        app.setActivationPolicy(.accessory)
        
        let window:NSWindow = app.windows[0]
        window.isOpaque = true
        window.backgroundColor = NSColor.clear
        window.hasShadow = false
        window.canHide = false
        window.level = 1
        window.isMovable = false
        window.isMovableByWindowBackground = false
        window.contentView?.wantsLayer = true
        
        if let layer = window.contentView?.layer {
            layer.cornerRadius = 1.0
            layer.borderWidth = 0
            layer.masksToBounds = true
            layer.backgroundColor = NSColor.white.withAlphaComponent(0.1).cgColor
        }
        
        ApplicationManager.applicationLastRegister()
        
        if let screen:NSScreen = NSScreen.main() {
            let size:CGSize = CGSize(width: window.frame.width, height: 30)
            let origin:CGPoint = CGPoint(x: screen.frame.origin.x, y: screen.frame.origin.x)
            let rect:CGRect = CGRect(origin: origin, size: size)
            
            window.setFrame(rect, display: true)
        }
        
        self.workspaceObserver = Observer(
            nc: NSWorkspace.shared().notificationCenter,
            name: nil,
            cb: { notification in
                self.workspaceNotificationLogger(notification:notification)
            }
        ).on()
    }
    
    func workspaceNotificationLogger(notification:Notification) {
        var applicationName:String = ""
        if let userInfo = notification.userInfo,
            let application:NSRunningApplication = userInfo["NSWorkspaceApplicationKey"] as? NSRunningApplication,
            let name = application.localizedName {
            applicationName = name
            
        }
        print(applicationName, notification.name.rawValue)
    }

}

