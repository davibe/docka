//
//  DockaView.swift
//  Docka
//
//  Created by Davide Bertola on 19/11/2016.
//  Copyright © 2016 Davide Bertola. All rights reserved.
//

import Foundation
import Cocoa

class StackView: NSStackView {
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.initialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
    
    func initialize() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alignment = .centerX
        self.distribution = .fillEqually
        self.orientation = .horizontal
        self.spacing = 0.0
    }
    
    override func viewDidMoveToSuperview() {
        self.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor).isActive = true
        self.widthAnchor.constraint(equalTo: self.superview!.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: self.superview!.heightAnchor).isActive = true
    }
    
}
