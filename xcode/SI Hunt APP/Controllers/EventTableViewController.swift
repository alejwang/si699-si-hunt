//
//  EventTableViewController.swift
//  ARKitImageRecognition
//
//  Created by Yi-Chen Weng on 2/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventTableViewController: UITableViewController {
    
    //Constants
    let APICLIENT_URL = "https://alejwang.pythonanywhere.com/events"
    let APICLIENT_URL_profile = "https://alejwang.pythonanywhere.com/profile"
    
    //MARK: Properties
    var events = [Event]()
    var recom_events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Load the sample data
        getEventData(url:APICLIENT_URL)
        
        //getUserTags(url:APICLIENT_URL_profile, username:"mark_newman")
        getRecommEventData(url:APICLIENT_URL_profile, username:"mark_newman")
        
        //        filterEventsByTags(allEvents:events, userTags:getUserTags(url:APICLIENT_URL_profile, username:"mark_newman"))
        //loadSampleEvents()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recom_events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "EventTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventTableViewCell else{
            fatalError("The dequeued cell is not an instance of EventTableViewCell")
        }
        
        let event = recom_events[indexPath.row]
        
        cell.nameLabel.text = event.name
        cell.timeLabel.text = event.start_time + " - " + event.end_time
        cell.locationLabel.text = event.location_name
        
        return cell
    }
    
    func getEventData(url: String){
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess{
                print("Success!Get the data")
                let eventJSON : JSON = JSON(response.result.value!)
                self.updateEventData(json:eventJSON)
            }
            else{
                print("Error")
            }
        }
    }
    
    func updateEventData(json:JSON) {
        let event_results = json["event_results"].arrayValue
        for event in event_results{
            events.append(Event(name: event["name"].stringValue,
                                description: event["description"].stringValue,
                                capacity: event["capacity"].intValue,
                                organizer_id: event["organizer_id"].intValue ,
                                organizer_name: event["organizer_name"].stringValue,
                                start_time: event["start_time"].stringValue,
                                end_time: event["end_time"].stringValue,
                                location_id: event["location_id"].intValue,
                                location_name: event["location_name"].stringValue,
                                location_is_armap_available: event["location_is_armap_available"].boolValue,
                                is_published: event["is_published"].boolValue,
                                pub_date: event["pub_date"].stringValue,
                                tags: event["tags"].arrayObject as! [String])!)
        }
        self.tableView.reloadData()
        
    }
    
    //    func getUserTags(url: String, username: String)->[String]? {
    //        var userTags = [String]()
    //        Alamofire.request(url + "/" + username, method: .get).responseJSON {
    //            response in
    //            if response.result.isSuccess{
    //                print("Success!Get the data")
    //                let profileJSON = JSON(response.result.value!)
    ////                self.updateEventData(json:eventJSON)
    //                userTags = profileJSON["tags"].arrayObject as! [String]
    //
    //            }
    //            else{
    //                print("Error")
    //            }
    //        }
    //        return userTags
    //    }
    
    func getRecommEventData(url: String, username: String){
        var userTags = [String]()
        Alamofire.request(url + "/" + username, method: .get).responseJSON {
            response in
            if response.result.isSuccess{
                print("Success!Get the data")
                let profileJSON = JSON(response.result.value!)
                //                self.updateEventData(json:eventJSON)
                userTags = profileJSON["tags"].arrayObject as! [String]
                self.updateRecommEventData(userTags: userTags)
            }
            else{
                print("Error")
            }
        }
    }
    
    func updateRecommEventData(userTags:[String]){
        self.getEventData(url:APICLIENT_URL)
        for event in events{
            for tag in event.tags{
                if userTags.contains(tag){
                    recom_events.append(event)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    //    func filterEventsByTags(allEvents: [Event], userTags: [String]){
    //        //var filteredEvents = [Event]()
    //        print(allEvents)
    //        print(userTags)
    //        for event in allEvents{
    //            for tag in event.tags{
    //                if userTags.contains(tag){
    //                    recom_events.append(event)
    //                }
    //            }
    //        }
    //        self.tableView.reloadData()
    //    }
    
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
    
    //    private func loadSampleEvents(){
    //        guard let event1 = Event(name:"2019 Orientation", time:"Mar.01.2019", location:"space2435") else{
    //            fatalError("Unable to instantiate event1")
    //        }
    //        guard let event2 = Event(name:"Information Expo", time:"Mar.03.2019", location:"space2435") else{
    //            fatalError("Unable to instantiate event2")
    //        }
    //
    //        events += [event1, event2]
    //    }
}
