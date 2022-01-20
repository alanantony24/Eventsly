//
//  Event.swift
//  Eventsly
//
//  Created by Keith Toh on 20/1/22.
//

import Foundation

class Event {
    
    var name:String
    var type:String
    var desc:String
    var pax:Int
    var date:Date
    var address:String
    
    init(name:String, type:String, desc:String, pax:Int, date:Date, address:String) {
        self.name = name
        self.type = type
        self.desc = desc
        self.pax = pax
        self.date = date
        self.address = address
    }
    
}

