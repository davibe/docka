//
//  ButtonIndexView.swift
//  Docka
//
//  Created by Davide Bertola on 26/11/2016.
//  Copyright © 2016 Davide Bertola. All rights reserved.
//

import Foundation
import Cocoa

class ButtonIndexView: NSTextView {
    
    convenience init() {
        self.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alignment = NSTextAlignment.center
        self.autoresizesSubviews = true
        self.font = NSFont(name: font!.fontName, size: 20)
        self.textColor = NSColor.white
        
        let shadow:NSShadow = NSShadow()
        shadow.shadowColor = NSColor.black
        shadow.shadowOffset = CGSize(width: 1.0, height: 1.0)
        shadow.shadowBlurRadius = 3.0
        
        self.shadow = shadow
        self.backgroundColor = NSColor.clear
        self.setText(text: "")
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil // don't be clickable
    }
    
    override func viewDidMoveToSuperview() {
        if self.superview == nil { return }
        self.widthAnchor.constraint(equalTo: self.superview!.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: self.superview!.heightAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor).isActive = true
    }
    
    func setText(text:String) {
        self.insertText(
            text,
            replacementRange: NSRangeFromString(self.string)
        )
    }
}
