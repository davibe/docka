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
    
    let workspaceObserver = WorkspaceObserver()
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let window:NSWindow = NSApplication.shared().windows[0]
        window.isOpaque = false
        window.backgroundColor = NSColor.white.withAlphaComponent(0.2)
        window.hasShadow = false
        window.canHide = false
        window.level = 1
        window.isMovable = false
        
        
        
        
        if let screen:NSScreen = NSScreen.main() {
            print(screen.frame)
            let size:CGSize = CGSize(width: screen.frame.width, height: 30)
            let origin:CGPoint = CGPoint(x: screen.frame.origin.x, y: screen.frame.origin.x)
            let rect:CGRect = CGRect(origin: origin, size: size)
            
            window.setFrame(rect, display: true)
            
        }
        
        let nc = NSWorkspace.shared().notificationCenter
        nc.addObserver(self.workspaceObserver, selector: #selector(WorkspaceObserver.observe), name: nil, object: nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

