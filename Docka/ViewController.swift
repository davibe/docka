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

class ViewController: NSViewController {

    let stackView = StackView()
    var timer:Timer = Timer()
    
    override func viewDidLoad() {
        self.viewCreate()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.refresh()
        let block:(Timer) -> Void = { timer in self.refresh() }
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: block)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        self.timer.invalidate()
    }
    
    func viewCreate() {
        self.view.addSubview(self.stackView)
        self.view.addSubview(self.stackView)
    }

    func refresh() {
        for subview in self.stackView.subviews { subview.removeFromSuperview() }
        let applications:[NSRunningApplication] = NSWorkspace.shared().runningApplications
        for application:NSRunningApplication in applications {
            if
                application.activationPolicy == .regular, // regular means it has UI
                let myBundleIdentifier = NSRunningApplication.current().bundleIdentifier,
                let bundleIndentifier = application.bundleIdentifier,
                myBundleIdentifier != bundleIndentifier // skip our own application
            {
                // print(application.localizedName)
                let icon = Button()
                icon.application = application
                icon.onClick = self.onClick
                self.stackView.addArrangedSubview(icon)
            }
        }
    }

    func onClick(button:Button, right:Bool) {
        let application = button.application
        if right {
            return self.applicationShowAlone(application: application)
        }
        self.applicationToggleHidden(application: application)
    }
    
    func applicationToggleHidden(application:NSRunningApplication) {
        NSRunningApplication.current().activate()
        
        if application.isHidden {
            application.activate()
            application.unhide()
        } else {
            application.hide()
        }
        self.refresh()
    }
    
    func applicationShowAlone(application:NSRunningApplication) {
        NSRunningApplication.current().activate()
        NSWorkspace.shared().hideOtherApplications()
        application.activate()
        application.unhide()
        self.refresh()
    }
}

