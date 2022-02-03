//
//  LoginViewController.swift
//  Eventsly
//
//  Created by MAD2 on 18/1/22.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var pwdFld: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    let signUpController = SignUpAndLoginController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupElements()
        
        emailFld.delegate = self
        emailFld.clearButtonMode = .whileEditing
        pwdFld.delegate = self
        pwdFld.clearButtonMode = .whileEditing
    }
    
    func SetupElements(){
        errorMessageLabel.alpha = 0
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        //Validate Inputs
        let email = emailFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = pwdFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Cleaned data lol
        Auth.auth().signIn(withEmail: email, password: password) { (result,error) in
            if error != nil{
                self.errorMessageLabel.text = error!.localizedDescription
                self.errorMessageLabel.alpha = 1
            }
            else{
                if true{
                    let storyboard = UIStoryboard(name: Constants.Storyboard.homeStoryBoard, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as UIViewController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        //takes back to rootviewcontroller
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailFld.resignFirstResponder()
        pwdFld.resignFirstResponder()
        return true
    }
}

