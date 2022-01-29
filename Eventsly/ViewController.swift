//
//  ViewController.swift
//  Eventsly
//
//  Created by MAD2 on 15/1/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AddTestData()
        
        // Do any additional setup after loading the view.
        if FirebaseAuth.Auth.auth().currentUser != nil{
            if true{
                let storyboard = UIStoryboard(name: Constants.Storyboard.homeStoryBoard, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as UIViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func AddTestData(){
        var event:[String:Any] = [
            "id": "E000001",
            "name": "Hunter Badminton Training Camp",
            "type": "Sports",
            "desc": "Making badminton available for everyone",
            "pax": 20,
            "date": "31/01/2022",
            "address": "535 Clementi Road Singapore 599489",
            "host_name": "John Clement",
            "num_attendees": 15
        ]
        database.child("Event").setValue(event)
    }
}

