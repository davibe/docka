//
//  ViewController.swift
//  Docka
//
//  Created by Davide Bertola on 19/11/2016.
//  Copyright © 2016 Davide Bertola. All rights reserved.
//

import Cocoa
import CoreFoundation
import Foundation
import Silica

class ViewController: NSViewController {

    let stackView = StackView()
    var workspaceObserver:Observer? = nil
    
    override func viewDidLoad() {
        self.view.addSubview(self.stackView)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        super.viewDidLoad()
        
        // on every workspace notification (app hide/activate/..) we refresh UI
        self.workspaceObserver = Observer(
            nc: NSWorkspace.shared.notificationCenter,
            name: nil,
            cb: { notification in self.refresh() }
        ).on()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.refresh()
    }

    func refresh() {
        for subview in self.stackView.subviews { subview.removeFromSuperview() }
        let applications:[NSRunningApplication] = NSWorkspace.shared.runningApplications
        for application:NSRunningApplication in applications {
            
            
            if
                application.activationPolicy == .regular, // regular means it has UI
                let myBundleIdentifier = NSRunningApplication.current.bundleIdentifier,
                let bundleIndentifier = application.bundleIdentifier,
                myBundleIdentifier != bundleIndentifier // skip our own application
            {
                let icon = Button()
                icon.application = application
                self.stackView.addArrangedSubview(icon)
            }
        }
    }

}

