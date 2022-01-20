//
//  LoginViewController.swift
//  Eventsly
//
//  Created by MAD2 on 18/1/22.
//

import Foundation
import UIKit

class LoginViewController:UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // for testing
    @IBAction func loginBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Content") as UIViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

