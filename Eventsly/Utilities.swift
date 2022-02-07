//
//  Utilities.swift
//  Eventsly
//
//  Created by Alan Antony on 23/1/22.
//  This class can be used for common functions that are used very often. These static functions can be called from any class within the project.

import Foundation
import UIKit

class Utilities{
    
    //This function is for checking the password strength. It will take in a string as the parameter and check whether the password follows the correct rules. The predicate object is used to cross examine the user entered password with the REGEX.
    static func isPasswordValid(_ password:String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
