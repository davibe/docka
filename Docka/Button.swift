//
//  Button.swift
//  Docka
//
//  Created by Davide Bertola on 19/11/2016.
//  Copyright © 2016 Davide Bertola. All rights reserved.
//

import Foundation
import Carbon
import Cocoa
import Silica
import StreamSwift


class Button: NSButton, Retainer {
    
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
    
    var mouseDownCb: (_ event: NSEvent) -> Void = { event in }
    override func mouseDown(with event: NSEvent) {
        mouseDownCb(event)
    }

}


func bindButton(
    view: Button,
    stream: Stream<AppState>,
    dispatch: @escaping (_ action: Action) -> Void,
    win: Win
) {
    view.image = win.application.icon
    
    view.retained += [
        stream
            .map { $0.hiddenWindowKeys }
            .distinct { $0 }
            .map { $0.contains(win.key) }
            .subscribe(strong: false) { [weak view] hidden in
                if hidden {
                    view?.alphaValue = 0.3
                } else {
                    view?.alphaValue = 1.0
                }
        }
    ]
    
    view.mouseDownCb = { event in
        let optionKeyDown = NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.option)
        if optionKeyDown {
            dispatch(WinTapSecondary(win: win))
        } else {
            dispatch(WinTap(win: win))
        }
    }
}
