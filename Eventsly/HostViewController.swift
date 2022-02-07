//
//  HostViewController.swift
//  Eventsly
//
//  Created by Low De Chuan on 25/1/22.
//

import Foundation
import UIKit
import FirebaseDatabase

class HostViewController:UIViewController, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate{
    
    let appdelgate = (UIApplication.shared.delegate) as! AppDelegate
    
    var eventCount:Int = 0
    
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var numofPaxInput: UITextField!
    //@IBOutlet weak var dateInput: UITextField!
    //@IBOutlet weak var timeInput: UITextField!
    @IBOutlet weak var datetimeInput: UITextField!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var categoryInput: UITextField!
    
    
    // DatePicker
    let datepicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionInput.delegate = self
        descriptionInput.clearButtonMode = .whileEditing
        numofPaxInput.delegate = self
        numofPaxInput.clearButtonMode = .whileEditing
        //dateInput.delegate = self
        //dateInput.clearButtonMode = .whileEditing
        //timeInput.delegate = self
        //timeInput.clearButtonMode - .whileEditing
        createDatePicker()
        locationInput.delegate = self
        locationInput.clearButtonMode = .whileEditing
        nameInput.delegate = self
        nameInput.clearButtonMode = .whileEditing
        categoryInput.delegate = self
        categoryInput.clearButtonMode = .whileEditing
    }
    
    func createDatePicker() {
        if #available(iOS 13.4, *)  {
        datepicker.preferredDatePickerStyle = .wheels
                }
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        // assign toobar
        datetimeInput.inputAccessoryView = toolbar
        
        // assign date picker to the text field
        datetimeInput.inputView = datepicker
    }
    
    @objc func donePressed() {
        datetimeInput.text = "\(datepicker.date)"
        self.view.endEditing(true)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        ClearInput()
    }
    
    func ClearInput(){
        nameInput.text = ""
        categoryInput.text = ""
        descriptionInput.text = ""
        numofPaxInput.text = ""
        //dateInput.text = ""
        //timeInput.text = ""
        datetimeInput.text = ""
        locationInput.text = ""
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        // Missing Input Validation
        if (nameInput == nil || nameInput.text == "") {
            let alert = UIAlertController(title: "Missing/Invalid Information", message: "Please key in your name for hosting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default,handler: { [weak self] (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (categoryInput == nil || categoryInput.text == "") {
            let alert = UIAlertController(title: "Missing/Invalid Information", message: "Please key in your category for hosting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default,handler: { [weak self]
                (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (descriptionInput == nil || descriptionInput.text == "") {
            let alert = UIAlertController(title: "Missing/Invalid Information", message: "Please key in your description for hosting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default,handler: { [weak self]
                (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (numofPaxInput == nil || numofPaxInput.text == "") {
            let alert = UIAlertController(title: "Missing/Invalid Information", message: "Please key in the number of pax for hosting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default,handler: { [weak self]
                (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (datetimeInput == nil || datetimeInput.text == "") {
            let alert = UIAlertController(title: "Missing/Invalid Information", message: "Please key in your date and time for hosting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default,handler: { [weak self]
                (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        /*else if (timeInput == nil || timeInput.text == "") {
            let alert = UIAlertController(title: "Missing/Invalid Information", message: "Please key in your time for hosting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default,handler: { [weak self]
                (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }*/
        else if (locationInput == nil || locationInput.text == "") {
            let alert = UIAlertController(title: "Missing/Invalid Information", message: "Please key in your location for hosting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default,handler: { [weak self]
                (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        else{
            let ref = Database.database().reference()

            //Get number of events to generate ID
            ref.child("Event").observe(.value, with: { (snapshot) in
                
                for event in snapshot.children.allObjects as! [DataSnapshot] {
                     
                    self.eventCount = self.eventCount + 1
                }
            })

            //alert user on creation success
            let alertController = UIAlertController(title: "You have successfully submitted the hosting information", message: "Thank you and have a nice day!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default) {
                (action: UIAlertAction!) in
                // Code in this block will trigger when OK button tapped.
                print("Ok button tapped");
                
                //generate unique event id
                var eventID:String = ""
                
                if (self.eventCount >= 0 && self.eventCount < 9)
                {
                    self.eventCount = self.eventCount + 1
                    eventID = "E000" + String(self.eventCount)
                }
                else if (self.eventCount >= 9 && self.eventCount < 99)
                {
                    self.eventCount = self.eventCount + 1
                    eventID = "E00" + String(self.eventCount)
                }
                else if (self.eventCount >= 99 && self.eventCount < 999)
                {
                    self.eventCount = self.eventCount + 1
                    eventID = "E0" + String(self.eventCount)
                }
                
                //upload data
                let postNewEvent = ["id": eventID,
                                    "name": self.nameInput.text!,
                                    "type": self.categoryInput.text!,
                                    "desc": self.descriptionInput.text!,
                                    "pax": self.numofPaxInput.text!,
                                    //"date": self.dateInput.text!,
                                    //"time": self.timeInput.text!,
                                    "date": self.datetimeInput.text!,
                                    "address": self.locationInput.text!,
                                    "host_name": self.appdelgate.loggedinUser.name,
                                    "num_attendees": "0"] as [String : Any]
                let childUpdatesNewEvent = ["Event/\(eventID)/": postNewEvent]
                ref.updateChildValues(childUpdatesNewEvent)
                self.ClearInput()
                self.tabBarController?.selectedIndex = 1
                
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionInput.resignFirstResponder()
        numofPaxInput.resignFirstResponder()
        //dateInput.resignFirstResponder()
        //timeInput.resignFirstResponder()
        locationInput.resignFirstResponder()
        nameInput.resignFirstResponder()
        categoryInput.resignFirstResponder()
        
        return true
    }
}
