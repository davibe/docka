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

class ApplicationManager {
    
    // We keep an updated reference of the last activated application before our own
    static var applicationLast:NSRunningApplication? = nil
    static var applicationLastObserver:Observer = Observer()
    
    class func applicationLastRegister() {
        applicationLastObserver = Observer(
            nc: NSWorkspace.shared().notificationCenter,
            name: "NSWorkspaceDidActivateApplicationNotification",
            cb: { (notification) in
                if
                    let userInfo = notification.userInfo,
                    let application = userInfo["NSWorkspaceApplicationKey"] as? NSRunningApplication,
                    application != NSRunningApplication.current()
                {
                    applicationLast = application
                }
        }).on()
    }
    
    class func toggleHidden(application:NSRunningApplication) {
        if
            application == applicationLast,
            !application.isHidden
        {
            // we are clicking the frontmost and visible application to hide it
            application.hide()
        } else {
            application.unhide()
            application.activate()
        }
    }
    
    class func showAlone(application:NSRunningApplication) {
        let applications:[NSRunningApplication] = NSWorkspace.shared().runningApplications
        for it:NSRunningApplication in applications {
            if it.bundleIdentifier == application.bundleIdentifier {
                application.unhide()
                application.activate()
        
                continue
            }
            
            if !it.isHidden { it.hide() }
        }
    }
    
    class func windowsRefit(application:NSRunningApplication) {
        // attempt to refit the application windows (experimental)
        
        let siApplication:SIApplication = SIApplication(runningApplication: application)
        if let windows:[SIWindow] = siApplication.windows() as! [SIWindow]? {
            for window in windows {
                if window.isNormalWindow() {
                    window.setFrame(
                        window.screen().frame.insetBy(dx: 60, dy: 60)
                    )
                }
            }
        }
        
    }
}
