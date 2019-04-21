//
//  leaderboardTableViewController.swift
//  ARKitImageRecognition
//
//  Created by Alejandro Wang on 4/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class leaderboardTableViewController: UITableViewController {
    
    var leaderboard: JSON = JSON()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
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
        
        getLeaderboardData()
    }
    
    // called when back button is pressed, always go back to homepage
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.leaderboard.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath)
        cell.textLabel!.font = UIFont(name: "IBM Plex Sans", size: 17)
        if leaderboard[indexPath.row]["username"].stringValue == UserDefaults.standard.string(forKey: "username") {
            cell.textLabel!.text = "\(indexPath.row+1) - You (\(leaderboard[indexPath.row]["points"].intValue) pts) "
            cell.textLabel!.textColor = #colorLiteral(red: 0.1865167618, green: 0.1482946575, blue: 0.8844041228, alpha: 1)
        } else {
            cell.textLabel!.text = "\(indexPath.row+1) - \(leaderboard[indexPath.row]["fistname"].stringValue) \(leaderboard[indexPath.row]["lastname"].stringValue) (\(leaderboard[indexPath.row]["points"].intValue) pts)"
            cell.textLabel!.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
        return cell
    }

    // pull profile data from API client
    func getLeaderboardData(){
        APIClient.getLeaderboard(completion: { json in
            if json != nil {
                self.leaderboard = json!["leaderboard_results"]
                self.tableView.reloadData()
//                print(json)
            } else {
                let alertController = UIAlertController(title: "😐 404", message:
                    "Can't get the leaderboard right now. You can try it later. ", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "🆗", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
        })
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
