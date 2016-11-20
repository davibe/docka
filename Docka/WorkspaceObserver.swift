//
//  WorkspaceObserver.swift
//  Docka
//
//  Created by Davide Bertola on 20/11/2016.
//  Copyright © 2016 Davide Bertola. All rights reserved.
//

import Foundation
import Cocoa


class WorkspaceObserver:NSObject {
    
    @objc func observe(notification: NSNotification) {
        var applicationName:String = ""
        
        if let userInfo = notification.userInfo,
            let application:NSRunningApplication = userInfo["NSWorkspaceApplicationKey"] as? NSRunningApplication,
            let name = application.localizedName {
            applicationName = name
            
        }
        
        print(applicationName, notification.name.rawValue)
    }
}
