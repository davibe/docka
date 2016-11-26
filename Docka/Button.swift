//
//  Button.swift
//  Docka
//
//  Created by Davide Bertola on 19/11/2016.
//  Copyright © 2016 Davide Bertola. All rights reserved.
//

import Foundation
import Cocoa

class Button: NSButton {
    
    let buttonIndexView:ButtonIndexView = ButtonIndexView()
    var index:Int = 0 {
        didSet {
            self.buttonIndexView.setText(text: "\(index)")
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isBordered = false
        self.imageScaling = .scaleProportionallyUpOrDown
        self.isEnabled = true
        self.highlight(false)
        self.addSubview(self.buttonIndexView)
    }
    
    var application:NSRunningApplication = NSRunningApplication.current {
        didSet {
            self.image = application.icon
            if application.isHidden {
                self.alphaValue = 0.3
            } else {
                self.alphaValue = 1.0
            }
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        if event.clickCount == 1 { ApplicationManager.toggleHidden(application: self.application) }
        if event.clickCount == 2 { ApplicationManager.showAlone(application: self.application) }
        if event.clickCount == 3 { ApplicationManager.windowsRefit(application: self.application) }
    }
}
