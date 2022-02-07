//
//  Event.swift
//  Eventsly
//
//  Created by Keith Toh on 20/1/22.
//

import Foundation

class Event {
    
    var id:String
    var name:String
    var type:String
    var desc:String
    var pax:Int
    var datetime:String
    var address:String
    var host_name:String
    var num_attendees:Int
    
    init(id:String, name:String, type:String, desc:String, pax:Int, datetime:String, address:String, host_name:String, num_attendees:Int) {
        self.id = id
        self.name = name
        self.type = type
        self.desc = desc
        self.pax = pax
        self.datetime = datetime
        self.address = address
        self.host_name = host_name
        self.num_attendees = num_attendees
    }
    
}

