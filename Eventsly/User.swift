//
//  User.swift
//  Eventsly
//
//  Created by Keith Toh on 20/1/22.
//

import Foundation

class User {
    
    var name:String
    var username:String
    var password:String
    var email:String
    var phone:Int32
    
    init(name:String, username:String, password:String, email:String, phone:Int32) {
        self.name = name
        self.username = username
        self.password = password
        self.email = email
        self.phone = phone
    }
    
}
