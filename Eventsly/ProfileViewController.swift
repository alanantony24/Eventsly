//
//  ProfileViewController.swift
//  Eventsly
//
//  Created by Keith Toh on 20/1/22.
//

import Foundation
import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        do{
            try FirebaseAuth.Auth.auth().signOut()
            if true{
                let storyboard = UIStoryboard(name: Constants.Storyboard.firstStoryBoard, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.firstViewController) as UIViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        catch{
            print("An error occured")
        }
    }
}
