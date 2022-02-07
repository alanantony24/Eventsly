//
//  SignUpAndLoginController.swift
//  Eventsly
//
//  Created by Alan Antony on 21/1/22.
//

import Foundation
import UIKit
import CoreData

class SignUpAndLoginController{
    
    var appDelegate:AppDelegate
    let context:NSManagedObjectContext

    init() {
        //Refering to the container
       appDelegate  = (UIApplication.shared.delegate) as! AppDelegate

        //Create a contect for this container
        context = appDelegate.persistentContainer.viewContext
    }
    
    //Add new Contact to CoreData
    func AddUserToCoreData(newUser : User){
        
        let entity = NSEntityDescription.entity(forEntityName: "CDUser", in: context)!
        
        let user = NSManagedObject(entity: entity, insertInto: context)
        
        user.setValue(newUser.name, forKey: "name")
        user.setValue(newUser.username, forKey: "username")
        user.setValue(newUser.email, forKey: "email")
        user.setValue(newUser.password, forKey: "password")
        user.setValue(newUser.phone, forKey: "phone")
        
        do{
            try context.save()
        }
        catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //Retrieve all contacts from Core Data
    func RetrieveAllUsersFromCoreData() -> [User]{
        var managedUserList:[NSManagedObject] = []
        var userList:[User] = []
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDUser")
        do{
            managedUserList = try context.fetch(fetchRequest)
            for i in managedUserList{
                let name = i.value(forKeyPath: "name") as! String
                let userName = i.value(forKeyPath: "username") as! String
                let email = i.value(forKeyPath: "email") as! String
                let password = i.value(forKeyPath: "password") as! String
                let phone = i.value(forKey: "phone") as! Int32
                let user:User = User(name: name, username: userName, password: password, email: email, phone: phone)
                userList.append(user)
            }
        }
        catch let error as NSError{
            print("Could not fetch, \(error), \(error.userInfo)")
        }
        return userList
    }
}
