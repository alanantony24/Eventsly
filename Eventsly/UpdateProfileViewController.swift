//
//  UpdateProfileViewController.swift
//  Eventsly
//
//  Created by MAD2 on 3/2/22.
//

import Foundation
import UIKit
import FirebaseFirestore

class UpdateProfileViewController:UIViewController{
    
    let db = Firestore.firestore()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var userNameUpdateBtn: UITextField!
    @IBOutlet weak var phNoUpdateBtn: UITextField!
    @IBOutlet weak var errorMsgLabel: UILabel!
    
    override func viewDidLoad() {
        SetUpElements()
        super.viewDidLoad()
    }
    
    //validation
    func ValidateAllFlds() -> String? {
        
        if(userNameUpdateBtn.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || phNoUpdateBtn.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            return "Please fill in all fields"
        }
        
        if(phNoUpdateBtn.text?.count != 8){
            return "The phone number should be 8 digits long."
        }
        return nil
    }
    
    func SetUpElements(){
        errorMsgLabel.alpha = 0
    }
    
    func ShowError(_ message:String){
        errorMsgLabel.text = message
        errorMsgLabel.alpha = 1
    }
    
    @IBAction func updateBtn(_ sender: Any) {
        
        let ref = db.collection("users").document(appDelegate.loggedinUser.name)
        
        let error = ValidateAllFlds()
        
        if(error != nil){
            //Error caught, prompt message
            ShowError(error!)
        }
        else{
            let cleanUserName = userNameUpdateBtn.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanPhNo = phNoUpdateBtn.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Update the username and password by going in to the collection with the user's name and
            //update the username and phonenumber by passing it in as a dictionary[String:Any].
            ref.updateData([
                "username": cleanUserName,
                "phNo": cleanPhNo
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    _ = self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
}
