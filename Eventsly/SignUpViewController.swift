//
//  SignUpViewController.swift
//  Eventsly
//
//  Created by Alan Antony on 18/1/22.
//  This class is to Sign Up the user with email and password using FireBase Authentication, and add the other data to the FireBase FireStore Database.

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController:UIViewController,UITextFieldDelegate{
    
    //Initialize the UI Elements such as textfiels and lables.
    @IBOutlet weak var nameFld: UITextField!
    @IBOutlet weak var userNameFld: UITextField!
    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var pwdFld: UITextField!
    @IBOutlet weak var cfmPwdFld: UITextField!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var errorMsgLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupElements()
        
        //This code is to give a cross button in the textfield to delete the input if the user wants to.
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
    
    //This function is called so that the error msg label will be invisible unless there's an error.
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
        
        //Check if password is strong and follows the rule of at least 8 characters including a number and a special character.(REGEX)
        if Utilities.isPasswordValid(cleanedPassword) == false || Utilities.isPasswordValid(cleanedCfmPassword) == false{
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        //Check if both passwords are correct
        if cleanedPassword != cleanedCfmPassword{
            return "Please make sure that both passwords are the same"
        }
        
        return nil
    }
    
    //When the Sign Up button is clicked, the below code kicks in.
    @IBAction func signUpBtn(_ sender: Any) {
        
        //Validating the text fields
        let error = ValidateFields()
        
        if error != nil{
            //Error caught, prompt message
            ShowError(error!)
        }
        else{
            //Create the final cleansed data.
            let name = nameFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let userName = userNameFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = pwdFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cfmPwd = cfmPwdFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phNo = phoneNo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create the users using FireBase Authentication.
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //Error Checking
                if err != nil{
                    self.ShowError("Error creating user")
                }
                else{
                    //Adding the other user data to the FireStore Database.
                    let db = Firestore.firestore()
                    db.collection("users").document(name).setData(["name":name, "username":userName, "email":email, "phNo":phNo, "uid": result!.user.uid]) { (error) in
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
    
    //Once the Login Instead Button is clicked, the below code kicks in.
    @IBAction func backBtn(_ sender: Any) {
        //Takes the user back to the login page if the user is already Signed Up.
        if true{
            let storyboard = UIStoryboard(name: Constants.Storyboard.firstStoryBoard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.loginPage) as UIViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //If there's any error message, then the error msg label is made visible and the text is set
    //to the error description.
    func ShowError(_ message:String){
        errorMsgLabel.text = message
        errorMsgLabel.alpha = 1
    }
    
    //Once the user is successfuly signed in, the user is taken to the home page of the application.
    func TransitionToHome(){
        if true{
            let storyboard = UIStoryboard(name: Constants.Storyboard.homeStoryBoard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as UIViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    //This code is to add a return button in the Phone/Simulator keyboard. Once the return button is hit, the keyboard goes back and the user can select the next field.
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
