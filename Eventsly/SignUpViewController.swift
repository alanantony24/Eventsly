//
//  SignUpViewController.swift
//  Eventsly
//
//  Created by MAD2 on 18/1/22.
//

import Foundation
import UIKit

class SignUpViewController:UIViewController{
    
    @IBOutlet weak var nameFld: UITextField!
    @IBOutlet weak var userNameFld: UITextField!
    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var pwdFld: UITextField!
    @IBOutlet weak var cfmPwdFld: UITextField!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var errorMsgLabel: UILabel!
    
    let signUpController = SignUpAndLoginController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func CheckUserExist(email:String, userName:String, phNo:Int32?) -> Bool{
        
        let userList:[User] = signUpController.RetrieveAllUsersFromCoreData()
        if userList.isEmpty{
            return false
        }
        for user in userList{
            if email==user.email || userName==user.username || phNo==user.phone{
                return true
            }
            else{
                return false
            }
        }
        return true
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate

        let context = appDelegate.persistentContainer.viewContext
        
        let name = nameFld.text!
        let username = userNameFld.text!
        let email = emailFld.text
        let pwd = pwdFld.text!
        let cfmPwd = cfmPwdFld.text!
        let phNo:Int32? = Int32(phoneNo.text!)
        
        var user:User = User(name: name, username: username, password: pwd, email: email!, phone: phNo!)
        
        if pwd == cfmPwd{
            if CheckUserExist(email: user.email, userName: user.username, phNo: user.phone) == false{
                signUpController.AddUserToCoreData(newUser: user)
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Content") as UIViewController
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
            else{
                errorMsgLabel.text = "The user already exists in the database. Consider logging in : )"
            }
        }
        else{
            errorMsgLabel.text = "The passwords must match! Please enter the correct passwords"
        }
    }
    
}
