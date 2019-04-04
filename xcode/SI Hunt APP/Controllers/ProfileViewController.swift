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
    
    var receivedUsername: String = ""
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
        button.setImage(UIImage(named: "backButton"), for: UIControlState.normal)
        button.frame = CGRect(x: 32 , y: 10, width: 60, height: 32)
        button.addTarget(self, action: #selector(ProfileViewController.backButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton

        // get data
        getProfileData(username: receivedUsername)
        getTagData()
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
    
    @IBAction func logoutFunction(_ sender: UIButton) {
        print("> Tapped Log out")
        navigationController?.popViewController(animated: true)
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
    
    // MARK: - Table view data source

    func getProfileData(username: String){
        let APICLIENT_URL = "https://alejwang.pythonanywhere.com/profile/"
        print("> requesting \(APICLIENT_URL) \(username)")
        Alamofire.request(APICLIENT_URL + username, method: .get).responseJSON {
            response in
            if response.result.isSuccess{
                print("Success!Get the data")
                let userProfileJSON : JSON = JSON(response.result.value!)
                self.updateProfileData(json:userProfileJSON)
            }
            else{
                print("Error")
            }
        }
    }
    
    func updateProfileData(json: JSON) {
        let username = json["username"].stringValue
        if username != "" {
            print("> To print username: \(username)")
            userUsernameLabel.text = username
        } else {
            userUsernameLabel.text = "Please log in"
        }
        let headline = json["description"].stringValue
        if headline != "" {
            headlineString = headline
        } else {
            headlineString = "I'm lazy and I don't want to introduce myself."
        }
        userTags = []
        for tag in json["tags"].arrayValue {
            userTags.append(tag.stringValue)
        }
//        print(tags)
        if userTags != [] {
            userHeadlineAndInterestLabel.text = "\(headlineString) \n- \nI am interested in \n\(userTags.joined(separator: ", "))"
        } else {
            userHeadlineAndInterestLabel.text = "\(headlineString) \n- \nNo interests for now..."
        }
    }
    
    func getTagData(){
        Alamofire.request("https://alejwang.pythonanywhere.com/tags", method: .get).responseJSON {
            response in
            if response.result.isSuccess{
                print("Success!Get the data")
                let tagsJSON : JSON = JSON(response.result.value!)
                for tagJSON in tagsJSON["tag_results"].arrayValue {
                    self.allTags.append(Tag(id: tagJSON["id"].intValue, name: tagJSON["name"].stringValue, priority: tagJSON["priority"].intValue)!)
                }
            }
            else{
                print("Error")
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoTagList" {
            // get a reference to the second view controller
            let destination = segue.destination as! ProfileInterestsTableViewController
            
            // set a variable in the second view controller with the String to pass
            destination.userTags = userTags
            destination.allTags = allTags
        }
    }
    
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ProfileInterestsTableViewController {
            if userTags != sourceViewController.userTags {
                userTags = sourceViewController.userTags
                if userTags != [] {
                    userHeadlineAndInterestLabel.text = "\(headlineString) \n- \nI am interested in \n\(userTags.joined(separator: ", "))"
                } else {
                    userHeadlineAndInterestLabel.text = "\(headlineString) \n- \nNo interests for now..."
                }
            }
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
