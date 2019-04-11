//
//  ProfileInterestsTableViewController.swift
//  ARKitImageRecognition
//
//  Created by Alejandro Wang on 3/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileInterestsTableViewController: UITableViewController {


    var userTags = [String]()
    var allTags = [Tag]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // rewrite nav bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        // rewrite nav bar back btn
        let button: UIButton = UIButton (type: UIButtonType.custom)
        button.setImage(UIImage(named: "backButton"), for: UIControlState.normal)
        button.frame = CGRect(x: 24 , y: 10, width: 24, height: 32)
        button.addTarget(self, action: #selector(ProfileViewController.backButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        // get data
        self.tableView.reloadData()
    }

    
    // called when back button is pressed, always go back to homepage
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allTags.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checklistCell", for: indexPath)
        cell.textLabel!.text = allTags[indexPath.row].name
        cell.textLabel!.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let isSelected = userTags.contains(allTags[indexPath.row].name)
        cell.setSelected(isSelected, animated: false)
        cell.accessoryType = isSelected ? .checkmark : .none
        return cell
        // TO FIX: setSelected is not working.
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        let item = allTags[indexPath.row]
        if let index = userTags.index(of: item.name) {
            userTags.remove(at: index)
        }
        userTags.append(allTags[indexPath.row].name)
        print("> userTags: \(userTags)")
    }
    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        let item = allTags[indexPath.row]
        if let index = userTags.index(of: item.name) {
            userTags.remove(at: index)
        }
        print("> userTags: \(userTags)")
    }
    

}
