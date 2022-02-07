//
//  LoginViewController.swift
//  Eventsly
//
//  Created by Alan Antony on 18/1/22.
//  This class contains the code for logging a user in using FireBase Authentication.

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    //Initialize the UI Elements such as textfiels and lables.
    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var pwdFld: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupElements()
        
        //This code is to give a cross button in the textfield to delete the input if the user wants to.
        emailFld.delegate = self
        emailFld.clearButtonMode = .whileEditing
        pwdFld.delegate = self
        pwdFld.clearButtonMode = .whileEditing
    }
    
    //This function is called so that the error msg label will be invisible unless there's an error.
    func SetupElements(){
        errorMessageLabel.alpha = 0
    }
    
    //When the login button is clicked, the below code kicks in.
    @IBAction func loginBtn(_ sender: Any) {
        
        //Validate Inputs and make sure that the fields are not empty.
        let email = emailFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = pwdFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Cleaned data is given as parameters to sign in the user.
        Auth.auth().signIn(withEmail: email, password: password) { (result,error) in
            //If there's any error message, then the error msg label is made visible and the text is set
            //to the error description.
            if error != nil{
                self.errorMessageLabel.text = error!.localizedDescription
                self.errorMessageLabel.alpha = 1
            }
            else{
                //Once logged in successfuly, the user is taken to the home page of the application.
                if true{
                    let storyboard = UIStoryboard(name: Constants.Storyboard.homeStoryBoard, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as UIViewController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    //Once the Sign Up instead button is clicked, this code kicks in.
    @IBAction func backBtn(_ sender: Any) {
        //If the user wants to Sign Up instead, the user is taken back to the Sign Up page.
        if true{
            let storyboard = UIStoryboard(name: Constants.Storyboard.firstStoryBoard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.signUpPage) as UIViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //This code is to add a return button in the Phone/Simulator keyboard. Once the return button is hit, the keyboard goes back and the user can select the next field.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailFld.resignFirstResponder()
        pwdFld.resignFirstResponder()
        return true
    }
}

