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
        //AddTestData()
        
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
            "id": "E000007",
            "name": "Plane Watching",
            "type": "Entertainment",
            "desc": "Watch and learn about the different planes that take off and land at Singapore Changi Airport",
            "pax":10,
            "date": "28/02/2022",
            "address": "Changi Airport Terminal 3, 65, Airport Boulevard, Singapore 819663",
            "host_name": "Mr Tay",
            "num_attendees": 5
        ]
        database.child("Event").childByAutoId().setValue(event)
    }
}

