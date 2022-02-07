//
//  Constants.swift
//  Eventsly
//
//  Created by Alan Antony on 23/1/22.
//  This class consists of the Constants that will be commonly used throughout the project. The string objects seen here are defined as static variables.

import Foundation


struct Constants{
    
    struct Storyboard{
        
        //These variables below are commonly used in this project to instantiate View Controllers and navigate the user to a certain view. Eg. after signing up/loggin in.
        
        //The 2 variables defined below are the storyboard names.
        static let homeStoryBoard = "Home"
        static let firstStoryBoard = "Main"
        
        //The 6 variables defined below are the view controller names.
        static let homeViewController = "HomeVC"
        static let firstViewController = "FirstVC"
        static let loginAndSignUp = "LoginAndSignUp"
        static let discoverPage = "DiscoverPage"
        static let signUpPage = "SignUpPage"
        static let loginPage = "LoginPage"
    }
}
