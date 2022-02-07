//
//  ViewController.swift
//  Eventsly
//
//  Created by Alan Antony on 15/1/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Lottie

class ViewController: UIViewController {

    //Initialize the FireBase Realtime Database
    private let database = Database.database().reference()
    
    //Added an animationview for the Lottie Animation
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //AddTestData()
        setupAnimation()
        
        // Do any additional setup after loading the view.
        //If user is already logged in, then the app will go to the home page of the application
        if FirebaseAuth.Auth.auth().currentUser != nil{
            if true{
                let storyboard = UIStoryboard(name: Constants.Storyboard.homeStoryBoard, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as UIViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    //This function is for adding some test data. Comment out the function in viewDidLoad accordingly.
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
    
    //This function us for adding the Lottie animation. The .json file is set up, then the dimensions are specified, and loop is set up to continiously loop. Finally the animation is added as a subview.
    func setupAnimation(){
        animationView.animation = Animation.named("loginsignup")
        animationView.frame = CGRect(x: 50, y: 200, width: 300, height: 300)
        animationView.backgroundColor = .white
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
}

