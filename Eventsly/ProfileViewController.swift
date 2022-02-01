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
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loggedinUser = appDelegate.loggedinUser
        
        lblName.text = "\(loggedinUser.name)"
        lblUsername.text = "Username: \(loggedinUser.username)"
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
