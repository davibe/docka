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
    
    convenience init() {
        self.init(frame: .zero)
        self.isBordered = false
        self.imageScaling = .scaleProportionallyUpOrDown
    }
    
    
    var application:NSRunningApplication = NSRunningApplication.current() {
        didSet {
            self.image = application.icon
            if application.isHidden {
                self.alphaValue = 0.3
            } else {
                self.alphaValue = 1.0
            }
        }
    }
    
    var onClick:(Button, Bool) -> Void = {button, right in }
    
    override func mouseDown(with event: NSEvent) {
        let right:Bool = event.buttonNumber == 1
        self.onClick(self, right)
    }
    
    override func rightMouseDown(with event: NSEvent) {
        let right:Bool = event.buttonNumber == 1
        self.onClick(self, right)
    }
    
    
}
