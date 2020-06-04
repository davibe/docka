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
import StreamSwift

class ViewController: NSViewController {

    let stackView = StackView()
    
    override func viewDidLoad() {
        self.view.addSubview(self.stackView)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
    }

    // state, dispatch
    
    var disposables = Array<Disposable>()

    func bindTo(
        stream: Stream<AppState>,
        dispatch: @escaping (_ action: Action) -> Void
    ) {
        disposables += [
            stream.map { $0.windows }.distinct({ $0 }).subscribe(replay: true) { windows in
                for subview in self.stackView.subviews { subview.removeFromSuperview() }
                windows.forEach({ win in
                    let icon = Button()
                    icon.bindTo(stream: stream, dispatch: dispatch, win: win)
                    self.stackView.addArrangedSubview(icon)
                })
            }
        ]
    }
    
    deinit {
        disposables.forEach { $0.dispose() }
        disposables = []
    }
}

