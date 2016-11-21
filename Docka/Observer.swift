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
    var callback:((NSNotification) -> Void)? = nil
    var name:NSNotification.Name? = nil
    var executeOnce = false
    
    convenience init(nc:NotificationCenter, name:String?, cb:((NSNotification) -> Void)?)
    {
        self.init()
        self.notificationCenter = nc
        if let n = name { self.name = NSNotification.Name(n) }
        self.callback = cb
    }
    
    func on()
    {
        self.notificationCenter.addObserver(
            self,
            selector: #selector(Observer.observe),
            name: self.name,
            object: nil
        )
    }
    
    func once()
    {
        self.executeOnce = true
        self.on()
    }
    
    func off()
    {
        self.notificationCenter.removeObserver(self)
    }
    
    @objc func observe(notification: NSNotification)
    {
        if self.executeOnce {
            self.off()
            self.executeOnce = false
        }
        self.callback?(notification)
    }
    
}
