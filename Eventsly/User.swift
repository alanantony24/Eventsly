//
//  User.swift
//  Eventsly
//
//  Created by Keith Toh on 20/1/22.
//

import Foundation

class User {
    
    var username:String
    var password:String
    var email:String
    var phone:Int
    
    init(username:String, password:String, email:String, phone:Int) {
        self.username = username
        self.password = password
        self.email = email
        self.phone = phone
    }
    
}
