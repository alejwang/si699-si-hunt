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
    var indexPathforDetail: IndexPath?
<<<<<<< Updated upstream
    var events = [Event]()
    var recom_events = [Event]()
    var mandatory_events = [Event]()
    var user_name : String! = ""
    var user_tags = [String]()
=======


    @IBAction func detailsPressed(_ sender: UIButton) {
        let button = sender
        let cell = button.superview!.superview! as! EventTableViewCell
        indexPathforDetail = tableView.indexPath(for: cell)
        //print(indexPathforDetail)
    }
>>>>>>> Stashed changes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        user_tags = getUserTags(url:APICLIENT_URL_profile, username:"mark_newman")
        //Load the sample data
        getEventData(url:APICLIENT_URL)
        getRecommEventData(url:APICLIENT_URL_profile, username:"mark_newman")
        //checkExpire(eventTime: "2019-03-31 18:00")
        
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
                print("Success!Get the events")
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
            let isExpired = self.checkExpire(eventTime: event["end_time"].stringValue)
            
            if isExpired == false{
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
        }
        self.tableView.reloadData()
        
    }
    
    func checkExpire(eventTime: String) -> Bool{
        let formatter = DateFormatter()
        formatter.dateFormat="yyyy-MM-dd HH:mm"
        let now = Date()
        if formatter.string(from: now)>eventTime{
            return true
        }
        else{
            return false
        }
    }
    
    func getRecommEventData(url: String, username: String){
        var userTags = [String]()
        Alamofire.request(url + "/" + username, method: .get).responseJSON {
            response in
            if response.result.isSuccess{
                print("Success!Get the profile")
                let profileJSON = JSON(response.result.value!)
                userTags = profileJSON["tags"].arrayObject as! [String]
                self.user_name = profileJSON["username"].stringValue
                self.user_tags = userTags
                self.updateRecommEventData(userTags: userTags)
            }
            else{
                print("Error")
            }
        }
    }
    
    func updateRecommEventData(userTags:[String]){
        //print(userTags)
        getEventData(url:APICLIENT_URL)
        for event in events{
            for tag in event.tags{
                if userTags.contains(tag){
                    recom_events.append(event)
                }
            }
        }
    }
    
//    func updateUserTags(userTags:[String]){
//        user_tags = userTags
//    }
//
//    func updateUserName(userName:String){
//        user_name = userName
//        print("name:" + userName)
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
    

     // MARK: - Navigation
    
    
    @IBAction func detailsPressed(_ sender: UIButton) {
        let button = sender
        let cell = button.superview!.superview! as! EventTableViewCell
        indexPathforDetail = tableView.indexPath(for: cell)
        print(indexPathforDetail!)
        //performSegue(withIdentifier: "seeEventDetail", sender: button)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if segue.identifier == "seeEventDetail" {
            //print(indexPathforDetail![1])
            let detailVC = segue.destination as! EventDetailViewController
            let event = events[indexPathforDetail![1]]
            detailVC.eventDescription = event.description
            detailVC.eventLocation = event.location_name
            detailVC.eventTitle = event.name
            detailVC.eventOrganizer = event.organizer_name
        }
        
<<<<<<< Updated upstream
     }

    
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
=======
        if segue.identifier == "startNavigation" {
            //print(indexPathforDetail![1])
            let navVC = segue.destination as! ViewController
            let event = events[indexPathforDetail![1]]
            navVC.eventLocation = event.location_name
            navVC.eventId = event.location_id
           
        }
        
    }
 
    
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
>>>>>>> Stashed changes
}
