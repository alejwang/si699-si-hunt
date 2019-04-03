//
//  NavigationTableViewController.swift
//  ARKitImageRecognition
//
//  Created by Alejandro Wang on 4/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

//
//protocol ContainerToMaster {
//    func changeLabel(newSteps: [String])
//}

class NavigationTableViewController: UITableViewController {
    
    var steps = [String]()
//    var containerToMaster: ContainerToMaster?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        print("> Step in stepVC: \(steps)")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return steps.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NavigationStepTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NavigationStepTableViewCell else {
            fatalError("The dequeued cell is not an instance of NavigationStepTableViewCell")
        }
        
        let step = steps[indexPath.row]
        cell.stepLable.text = step
  
        return cell
    }

//    override func viewDidLayoutSubviews() {
//        tableView.frame.size = tableView.contentSize
//    }
    

//    func changeLabel(newSteps: [String]) {
////        labelContainer.text = text
//        steps = newSteps
//        self.tableView.reloadData()
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
