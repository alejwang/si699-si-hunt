//
//  testTableTableViewController.swift
//  ARKitImageRecognition
//
//  Created by Yi-Chen Weng on 4/7/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TestEventTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //Constants
    let APICLIENT_URL = "https://alejwang.pythonanywhere.com/events"
    let APICLIENT_URL_profile = "https://alejwang.pythonanywhere.com/profile"
    
    //MARK: Properties
    var indexPathforDetail: IndexPath?
    var events = [Event]()
    var recom_events = [Event]()
    var mandatory_events = [Event]()
    var user_name : String! = ""
    var user_tags = [String]()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        getEventData(url:APICLIENT_URL)
        getRecommEventData(url:APICLIENT_URL_profile, username:"mark_newman")
    }

    
    @IBAction func profileBtnPressed(_ sender: UIButton) {
        if UserDefaults.standard.string(forKey: "username") != nil {
            performSegue(withIdentifier: "gotoProfile3", sender: self)
        } else {
            performSegue(withIdentifier: "gotoLogin", sender: self)
        }
        
    }
    
    @IBAction func profileTextPressed(_ sender: UIButton) {
        if UserDefaults.standard.string(forKey: "username") != nil {
            performSegue(withIdentifier: "gotoProfile3", sender: self)
        } else {
            performSegue(withIdentifier: "gotoLogin", sender: self)
        }
    }
    

    // MARK: - Table view data source
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // rewrite (hide) the nb
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // rewrite (show) the nb
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileBtn", for: indexPath) as! ProfileBtnTableViewCell
            return cell
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecommEventsTableCell", for: indexPath) as! RecommEventsTableViewCell
            //cell.events = recom_events
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllEventsTableCell", for: indexPath) as! AllEventsTableViewCell
            //cell.events = events
            return cell
        }
        
        // Configure the cell...

        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            if let cell = cell as? RecommEventsTableViewCell {
                cell.recommCollectionView.dataSource = self
                cell.recommCollectionView.delegate = self
                cell.recommCollectionView.tag = indexPath.row
                cell.recomEventCount.text = String(recom_events.count)
                cell.recommCollectionView.reloadData()
            }
        } else if indexPath.row == 3 {
            if let cell = cell as? AllEventsTableViewCell {
                cell.allEventsCollectionView.dataSource = self
                cell.allEventsCollectionView.delegate = self
                cell.allEventsCollectionView.tag = indexPath.row
                cell.totalEventCount.text = String(events.count)
                cell.allEventsCollectionView.reloadData()
                cell.allEventsCollectionView.isScrollEnabled = false
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return tableView.bounds.width + 65
        } else if indexPath.row == 3{
            return CGFloat(events.count*100+30)
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let datasourceIndex = collectionView.tag
        if datasourceIndex == 2{
            return recom_events.count
        } else if datasourceIndex == 3 {
            return events.count
        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let datasourceIndex = collectionView.tag
        if datasourceIndex == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommEventsCollectionCell", for: indexPath) as! RecommCollectionViewCell
            
            let event = recom_events[indexPath.row]
            
            
            cell.eventName.text = event.name
            cell.eventTime.text = event.start_time
            //cell.eventLocation.text = event.location_name
            cell.eventImage.image = UIImage(named: "recommEvent")
            
            
//            cell.contentView.layer.cornerRadius = 5.0
//            cell.contentView.layer.borderWidth = 1.0
//            cell.contentView.layer.borderColor = UIColor.clear.cgColor
//            cell.layer.shadowColor = UIColor.gray.cgColor
//            cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//            cell.layer.shadowRadius = 4.0
//            cell.layer.shadowOpacity = 1.0
//            cell.layer.masksToBounds = false
//            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            
            return cell
        }else if datasourceIndex == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllEventsCollectionCell", for: indexPath) as! AllEventsCollectionViewCell
    
            let event = events[indexPath.row]
            cell.eventName.text = event.name
            cell.eventTime.text = event.start_time + " - " + event.end_time
    
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func getEventData(url: String){
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess{
                print("Success!Get the events")
                let eventJSON : JSON = JSON(response.result.value!)
                self.updateEventData(json:eventJSON)
                //self.totalEventCount.text = String(self.events.count)
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
        
        print(events)
        //mandCollectionView.reloadData()
        //recomCollectionView.reloadData()
        //allEventsCollectionView.reloadData()
        //recomCollectionView.reloadData()
        //allEventsTableView.reloadData()
        //self.collectionView.reloadData()
        tableView.reloadData()
        
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
                //self.recomEventCount.text = String(self.recom_events.count)
            }
            else{
                print("Error")
            }
        }
    }
    
    func updateRecommEventData(userTags:[String]){
        getEventData(url:APICLIENT_URL)
        for event in events{
            for tag in event.tags{
                if userTags.contains(tag){
                    recom_events.append(event)
                    break
                }
            }
        }
        tableView.reloadData()
    }


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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DvC = Storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
        
        DvC.getImage = UIImage(named: "recommEvent")!
        
        let datasourceIndex = collectionView.tag
        let event: Event
        
        if datasourceIndex == 2{
            event = recom_events[indexPath.row]
        }else{
            event = events[indexPath.row]
        }
        
        DvC.getName = event.name
        DvC.getTime = event.start_time + " - " + event.end_time
        DvC.getLocation = event.location_name
        DvC.getDescription = event.description
        DvC.eventId = event.location_id
        DvC.eventlocationName = event.location_name
        
        
        self.navigationController?.pushViewController(DvC, animated: true)
    }
    
        @IBAction func unwindToHomepage(segue:UIStoryboardSegue) { }
}


