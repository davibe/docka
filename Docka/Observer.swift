//
//  NotificationHub.swift
//  Docka
//
//  Created by Davide Bertola on 21/11/2016.
//  Copyright © 2016 Davide Bertola. All rights reserved.
//

import Foundation

class Observer {
    var notificationCenter:NotificationCenter = NotificationCenter()
    var callback:((Notification) -> Void)? = nil
    var name:Notification.Name? = nil
    var executeOnce = false
    
    convenience init(nc:NotificationCenter?, name:String?, cb:((Notification) -> Void)?)
    {
        self.init()
        self.notificationCenter = NotificationCenter.default
        if let n = nc { self.notificationCenter = n }
        if let n = name { self.name = Notification.Name(n) }
        self.callback = cb
    }
    
    func on() -> Observer
    {
        self.notificationCenter.addObserver(
            self,
            selector: #selector(Observer.observe),
            name: self.name,
            object: nil
        )
        return self
    }
    
    func once() -> Observer
    {
        self.executeOnce = true
        return self.on()
    }
    
    func off() -> Observer
    {
        self.notificationCenter.removeObserver(self)
        return self
    }
    
    @objc func observe(notification: Notification)
    {
        if self.executeOnce {
            self.off()
            self.executeOnce = false
        }
        self.callback?(notification)
    }
    
}
