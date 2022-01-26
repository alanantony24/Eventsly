//
//  HostViewController.swift
//  Eventsly
//
//  Created by Low De Chuan on 25/1/22.
//

import Foundation
import UIKit
import FirebaseDatabase

class HostViewController:UIViewController, UITextViewDelegate, UINavigationControllerDelegate{
    let appdelgate = (UIApplication.shared.delegate) as! AppDelegate
    
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var numofPaxInput: UITextField!
    @IBOutlet weak var dateInput: UITextField!
    @IBOutlet weak var timeInput: UITextField!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var categoryInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        nameInput.text = ""
        categoryInput.text = ""
        descriptionInput.text = ""
        numofPaxInput.text = ""
        dateInput.text = ""
        timeInput.text = ""
        locationInput.text = ""
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        // Missing Input Validation
        if (nameInput == nil || nameInput.text == "") {
            let alert = UIAlertController(title: "Missing/Invalid Information", message: "Please key in your name for hosting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Comfirm", style: .default,handler: { [weak self] (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (categoryInput == nil || categoryInput.text == "") {
            let alert = UIAlertController(title: "Missing/Invalid Information", message: "please key in your category for hosting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Comfirm", style: .default,handler: { [weak self]
                (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (descriptionInput == nil || descriptionInput.text == "") {
            let alert = UIAlertController(title: "Missing/Invalid Information", message: "please key in your description for hosting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default,handler: { [weak self]
                (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (numofPaxInput == nil || numofPaxInput.text == "") {
            let alert = UIAlertController(title: "Missing/Invalid Information", message: "please key in the number of pax for hosting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default,handler: { [weak self]
                (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (dateInput == nil || dateInput.text == "") {
            let alert = UIAlertController(title: "Missing/Invalid Information", message: "please key in your date for hosting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default,handler: { [weak self]
                (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (timeInput == nil || timeInput.text == "") {
            let alert = UIAlertController(title: "Missing/Invalid Information", message: "please key in your time for hosting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default,handler: { [weak self]
                (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (locationInput == nil || locationInput.text == "") {
            let alert = UIAlertController(title: "Missing/Invalid Information", message: "please key in your location for hosting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default,handler: { [weak self]
                (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        else{
            //Upload Data Here
            let ref = Database.database().reference()
            ref.child("Event").childByAutoId().setValue(["name": nameInput.text!, "type": categoryInput.text!, "desc": descriptionInput.text!, "num_attendees": numofPaxInput.text!, "date":dateInput.text!, "time":timeInput.text!, "address":locationInput.text!])
            
            let alertController = UIAlertController(title: "You have successfully submitted the hosting information", message: "Thank you and have a nice day!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default) {
                (action: UIAlertAction!) in
                // Code in this block will trigger when OK button tapped.
                print("Ok button tapped");
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
