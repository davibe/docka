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
    
    // state, dispatch
    
    var disposables = Array<Disposable>()
    let mouseDown = Stream<NSEvent>(memory: false)
    
    func bindTo(
        stream: Stream<AppState>,
        dispatch: @escaping (_ action: Action) -> Void,
        win: Win
    ) {
        self.image = win.application.icon
        
        disposables += [
            mouseDown,
            stream.map { $0.hiddenWindowKeys }.distinct({ $0 }).subscribe { hiddenWinKeys in
                let hidden = hiddenWinKeys.contains(win.key)
                if hidden {
                    self.alphaValue = 0.3
                } else {
                    self.alphaValue = 1.0
                }
            },
            mouseDown.subscribe(replay: false) { event in
                let optionKeyDown = NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.option)
                if optionKeyDown {
                    dispatch(WinTapSecondary(win: win))
                } else {
                    dispatch(WinTap(win: win))
                }
            }
        ]
    }
    
    override func mouseDown(with event: NSEvent) {
        mouseDown.trigger(event)
    }
}
