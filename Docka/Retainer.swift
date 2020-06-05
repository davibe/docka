//
//  Retainer.swift
//  Docka
//
//  Created by Davide Bertola on 05/06/2020.
//  Copyright © 2020 Davide Bertola. All rights reserved.
//

import Foundation

// Who adopts this protocol is capable of retain any object
// This allows for example to 'bind' any object ref to the lifecycle of a UIView

protocol Retainer: AnyObject {
    var retained: Array<Any> { get set }
}


fileprivate var retainerKey = "retainerKeyUnlikelyToClash"


extension Retainer {
    var retained: Array<Any> {
        get {
            return objc_getAssociatedObject(self, &retainerKey) as? [Any] ?? []
        }
        set {
            objc_setAssociatedObject(self, &retainerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
