//
//  LoginViewController.swift
//  Eventsly
//
//  Created by MAD2 on 18/1/22.
//

import Foundation
import UIKit

class LoginViewController:UIViewController{
    
    @IBOutlet weak var userNameFld: UITextField!
    @IBOutlet weak var pwdFld: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let signUpController = SignUpAndLoginController()
    
    func CheckUserExistsInCoreData(userName:String, passWord:String) -> Bool{
        
        let userList:[User] = signUpController.RetrieveAllUsersFromCoreData()
        if userList.isEmpty{
            errorMessageLabel.text = "There's no data in the database."
            return false
        }
        for user in userList{
            if userName==user.username && passWord==user.password{
                return true
            }
            else{
                errorMessageLabel.text = "Wrong password or username!"
                return false
            }
        }
        return false
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if CheckUserExistsInCoreData(userName: userNameFld.text!, passWord: pwdFld.text!) == true{
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Content") as UIViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}

