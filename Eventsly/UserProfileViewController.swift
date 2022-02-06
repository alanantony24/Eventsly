//
//  UserProfileViewController.swift
//  Eventsly
//
//  Created by Keith Toh on 6/2/22.
//

import Foundation
import UIKit
import FirebaseAuth

class UserProfileViewController: UITableViewController {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userInfo:[String] = []
    var userInfoList:[String] = []

    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loggedinUser = appDelegate.loggedinUser

        lblName.text = "\(loggedinUser.name)"
        
        userInfoList.append("Username")
        userInfoList.append("Email")
        userInfoList.append("Mobile Number")
        
        userInfo.append(loggedinUser.username)
        userInfo.append(loggedinUser.email)
        userInfo.append(String(loggedinUser.phone))
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
            case 0: return userInfoList.count
            case 1: return 1
            case 2: return 1
            case 3: return 1
            default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch((indexPath as NSIndexPath).section){
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "userInfoCell", for: indexPath)

            cell.textLabel!.text = userInfoList[(indexPath as NSIndexPath).row]
            cell.detailTextLabel!.text = userInfo[(indexPath as NSIndexPath).row]
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "viewCell", for: indexPath)
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "updateCell", for: indexPath)
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "logoutCell", for: indexPath)
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "userInfoCell", for: indexPath)

            cell.textLabel!.text = ""
            cell.detailTextLabel!.text = ""
            
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch((indexPath as NSIndexPath).section){
            case 0: self.tableView.reloadData()
            case 1: self.tableView.reloadData()
            case 2: self.tableView.reloadData()
            case 3: userLogoutAlert()
                        
            default: self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
            case 0: return " "
            case 1: return ""
            case 2: return ""
            case 3: return ""
            default: return ""
        }
    }
    
    func userLogoutAlert()
    {
        let alertViewLogout = UIAlertController(
            title: "Log Out",
            message: "Do you wish to log out from your current account?",
            preferredStyle: UIAlertController.Style.alert)

        alertViewLogout.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in }))

        alertViewLogout.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { _ in
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
        }))
        
        self.present(alertViewLogout, animated: true, completion: nil)
    }
    
}
