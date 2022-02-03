//
//  SignUpViewController.swift
//  Eventsly
//
//  Created by MAD2 on 18/1/22.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController:UIViewController,UITextFieldDelegate{
    
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
        SetupElements()
        
        nameFld.delegate = self
        nameFld.clearButtonMode = .whileEditing
        userNameFld.delegate = self
        userNameFld.clearButtonMode = .whileEditing
        emailFld.delegate = self
        emailFld.clearButtonMode = .whileEditing
        pwdFld.delegate = self
        pwdFld.clearButtonMode = .whileEditing
        cfmPwdFld.delegate = self
        cfmPwdFld.clearButtonMode = .whileEditing
        phoneNo.delegate = self
        phoneNo.clearButtonMode = .whileEditing
    }
    
    func SetupElements(){
        errorMsgLabel.alpha = 0
    }
    
    //Check the fields and validate the data is correct. If not correct data, then prompt error message
    func ValidateFields() -> String?{
        
        //Check all fileds are filled
        if nameFld.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" ||
            userNameFld.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" ||
            emailFld.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" ||
            pwdFld.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" ||
            cfmPwdFld.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" ||
            phoneNo.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" {
            
            return  "Please fill in all fields"
        }
        
        let cleanedPassword = pwdFld.text!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let cleanedCfmPassword = cfmPwdFld.text!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        //Check if password is strong (REGEX)
        if Utilities.isPasswordValid(cleanedPassword) == false || Utilities.isPasswordValid(cleanedCfmPassword) == false{
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        //Check if both passwords are correct
        if cleanedPassword != cleanedCfmPassword{
            return "Please make sure that both passwords are the same"
        }
        
        return nil
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        
        //Validating the text fields
        let error = ValidateFields()
        
        if error != nil{
            //Error caught, prompt message
            ShowError(error!)
        }
        else{
            //Create the final cleansed data
            let name = nameFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let userName = userNameFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = pwdFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cfmPwd = cfmPwdFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phNo = phoneNo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //Create the users
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //Error Checking
                if err != nil{
                    self.ShowError("Error creating user")
                }
                else{
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(name).setData(["name":name, "username":userName, "phNo":phNo, "uid": result!.user.uid]) { (error) in
                        if error != nil{
                            self.ShowError("User could not be created : (")
                        }
                    }
                    //Go to the Home.storyboard
                    self.TransitionToHome()
                }
            }
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    func ShowError(_ message:String){
        errorMsgLabel.text = message
        errorMsgLabel.alpha = 1
    }
    
    func TransitionToHome(){
        if true{
            let storyboard = UIStoryboard(name: Constants.Storyboard.homeStoryBoard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as UIViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameFld.resignFirstResponder()
        userNameFld.resignFirstResponder()
        emailFld.resignFirstResponder()
        pwdFld.resignFirstResponder()
        cfmPwdFld.resignFirstResponder()
        phoneNo.resignFirstResponder()
        return true
    }
}
