//
//  LoginViewController.swift
//  Eventsly
//
//  Created by MAD2 on 18/1/22.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController:UIViewController{
    
    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var pwdFld: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    let signUpController = SignUpAndLoginController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupElements()
    }
    
    func SetupElements(){
        errorMessageLabel.alpha = 0
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        //Validate Inputs
        let email = emailFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = pwdFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Cleaned data
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
        if true{
            let storyboard = UIStoryboard(name: Constants.Storyboard.firstStoryBoard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.loginAndSignUp) as UIViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}

