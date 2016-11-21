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


class ApplicationManager {
    
    class func toggleHidden(application:NSRunningApplication) {
        NSRunningApplication.current().activate()
        
        if application.isHidden {
            application.activate()
            application.unhide()
        } else {
            application.hide()
        }
    }
    
    class func showAlone(application:NSRunningApplication) {
        let applications:[NSRunningApplication] = NSWorkspace.shared().runningApplications
        for it:NSRunningApplication in applications {
            if it.bundleIdentifier == application.bundleIdentifier {
                application.activate()
                application.unhide()
                continue
            }
            
            if !it.isHidden { it.hide() }
        }
    }
}
