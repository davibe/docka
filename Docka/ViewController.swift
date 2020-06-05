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


class ViewController: NSViewController, Retainer {
    
    let stackView = StackView()
    
    override func viewDidLoad() {
        self.view.addSubview(self.stackView)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
    }
    
}


func bindViewController(
    vc: ViewController,
    stream: Stream<AppState>,
    dispatch: @escaping (_ action: Action) -> Void
) {
    vc.retained += [
        stream
            .map { $0.windows }
            .distinct({ $0 })
            .subscribe(replay: true) { [weak vc] windows in
                guard let vc = vc else { return }
                for subview in vc.stackView.subviews { subview.removeFromSuperview() }
                windows.forEach({ win in
                    let icon = Button()
                    bindButton(view: icon, stream: stream, dispatch: dispatch, win: win)
                    vc.stackView.addArrangedSubview(icon)
                })
        }
    ]
}
