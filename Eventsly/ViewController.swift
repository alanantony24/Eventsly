//
//  ViewController.swift
//  Eventsly
//
//  Created by MAD2 on 15/1/22.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
}

