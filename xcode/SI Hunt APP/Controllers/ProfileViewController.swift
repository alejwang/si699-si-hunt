//
//  ProfileTableViewController.swift
//  
//
//  Created by Alejandro Wang on 3/25/19.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userFullnameLabel: UILabel!
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var userHeadlineAndInterestLabel: UILabel!
    
    @IBOutlet weak var chooseInterestButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var fullname: String = ""
    var username: String = "John Doe"
    var headlineString : String = ""
    var userTags = [String]()
    var allTags = [Tag]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // rewrite nav bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2403589189, green: 0.2626186907, blue: 0.8809275031, alpha: 1)
        
        // rewrite nav bar back btn
        let button: UIButton = UIButton (type: UIButtonType.custom)
        button.setImage(UIImage(named: "backButtonBlack"), for: UIControlState.normal)
        button.frame = CGRect(x: 24 , y: 10, width: 24, height: 32)
        button.addTarget(self, action: #selector(ProfileViewController.backButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton

        // rewrite the action buttons
        chooseInterestButton.titleEdgeInsets = UIEdgeInsetsMake(0, -chooseInterestButton.imageView!.frame.size.width-8, 0, chooseInterestButton.imageView!.frame.size.width+8);
        chooseInterestButton.imageEdgeInsets = UIEdgeInsetsMake(0, chooseInterestButton.titleLabel!.frame.size.width, 0, -chooseInterestButton.titleLabel!.frame.size.width);
        logoutButton.titleEdgeInsets = UIEdgeInsetsMake(0, -logoutButton.imageView!.frame.size.width-8, 0, logoutButton.imageView!.frame.size.width+8);
        logoutButton.imageEdgeInsets = UIEdgeInsetsMake(0, logoutButton.titleLabel!.frame.size.width, 0, -logoutButton.titleLabel!.frame.size.width);
        chooseInterestButton.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        chooseInterestButton.layer.shadowOffset = CGSize(width: 0, height: 8)
        chooseInterestButton.layer.shadowOpacity = 0.1
        chooseInterestButton.layer.shadowRadius = 5
        logoutButton.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        logoutButton.layer.shadowOffset = CGSize(width: 0, height: 8)
        logoutButton.layer.shadowOpacity = 0.1
        logoutButton.layer.shadowRadius = 5
        
        
        // get data
        if username != UserDefaults.standard.string(forKey: "username") {
            username = UserDefaults.standard.string(forKey: "username")!
            getProfileData(username: username)
        }
        if allTags.count == 0 {
            getTagData()
        }
    }
    
    
    // called when back button is pressed, always go back to homepage
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToHomepage1", sender: self)
    }
    
    
    // log out to clean UD standard and go back to homepage
    @IBAction func logoutFunction(_ sender: UIButton) {
        print("> Tapped Log out")
        let alert = UIAlertController(title: "Do you want to log out? ", message: "😭😭😭😭😭😭", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { action in
            UserDefaults.standard.removeObject(forKey: "username")
            self.navigationController?.popViewController(animated: true)
            self.performSegue(withIdentifier: "unwindSegueToHomepage1", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    // pull profile data from API client
    func getProfileData(username: String){
        APIClient.getProfile(withUsername: username, completion: { json in
            if json != nil {
                self.fullname = "\(json!["fistname"].stringValue) \(json!["lastname"].stringValue)"
                self.headlineString = json!["description"].stringValue
                self.userTags = []
                for tag in json!["tags"].arrayValue {
                    self.userTags.append(tag.stringValue)
                }
                self.updateProfileData()
            } else {
                let alertController = UIAlertController(title: "😐 404", message:
                    "Can't get your profile right now. You can try it later. ", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "🆗", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    
    // update view by current vars
    func updateProfileData() {
        if userFullnameLabel.text == "" {
            userFullnameLabel.text = "John Doe"
        } else {
            userFullnameLabel.text = fullname
        }
        userUsernameLabel.text = "@\(username)"
        if headlineString == "" {
            headlineString = "I'm lazy and I don't want to introduce myself."
        }
        if userTags != [] {
            userHeadlineAndInterestLabel.text = "\(headlineString) \n- \nI am interested in \n\(userTags.joined(separator: ", "))"
        } else {
            userHeadlineAndInterestLabel.text = "\(headlineString) \n- \nNo interests for now..."
        }
    }
    
    
    // get all_tags by API Client
    func getTagData(){
        APIClient.getTagList { json in
            for tagJSON in json!["tag_results"].arrayValue {
                self.allTags.append(Tag(id: tagJSON["id"].intValue, name: tagJSON["name"].stringValue, priority: tagJSON["priority"].intValue)!)
            }
        }
    }

    
    // prepare for changing tags view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoTagList" {
            // get a reference to the second view controller
            let destination = segue.destination as! ProfileInterestsTableViewController
            
            // set a variable in the second view controller with the String to pass
            destination.userTags = userTags
            destination.allTags = allTags
        }
    }
    
    
    // prepare for unwind with new tags information
    @IBAction func unwindToProfile(sender: UIStoryboardSegue) {
        print("> unwind called")
        if let sourceViewController = sender.source as? ProfileInterestsTableViewController {
            print("> userTags unwind: \(sourceViewController.userTags)")
            if userTags != sourceViewController.userTags {
                userTags = sourceViewController.userTags
                updateProfileData()
            }
        }
    }

}
