//
//  EventViewController.swift
//  ARKitImageRecognition
//
//  Created by Yi-Chen Weng on 4/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
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
    
    //test data
//    let testEventNames = ["name1", "name2"]
//    let testEventTimes = ["time1", "time2"]
//    let testEventLocations = ["location1", "location2"]

 
    
    @IBOutlet weak var recomCollectionView: UICollectionView!
    //@IBOutlet weak var mandCollectionView: UICollectionView!
    @IBOutlet weak var allEventsCollectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        // Do any additional setup after loading the view.
        getEventData(url:APICLIENT_URL)
        getRecommEventData(url:APICLIENT_URL_profile, username:"mark_newman")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
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
    
    @IBAction func profileButtonTapped(_ sender: UIBarButtonItem) {
        if UserDefaults.standard.string(forKey: "username") != nil {
            performSegue(withIdentifier: "gotoProfile3", sender: self)
        } else {
            performSegue(withIdentifier: "gotoLogin", sender: self)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return testEventNames.count
        if collectionView == self.allEventsCollectionView{
            return events.count
        }
        else if collectionView == self.recomCollectionView{
            return recom_events.count
        }
        else{
            return events.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.recomCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recomEventCell", for: indexPath) as! CollectionViewCell
            
            let event = recom_events[indexPath.row]
            
            
            cell.eventName.text = event.name
            cell.eventTime.text = event.start_time + " - " + event.end_time
            //cell.eventLocation.text = event.location_name
            cell.eventImage.image = UIImage(named: "recommEvent")
            
            
            cell.contentView.layer.cornerRadius = 5.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            cell.layer.shadowRadius = 4.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            
           
           return cell
            
        }else if collectionView == self.allEventsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allEventsCell", for: indexPath) as! AllEventsCollectionViewCell
            
            let event = events[indexPath.row]
            
            
            cell.eventName.text = event.name
            cell.eventTime.text = event.start_time + " - " + event.end_time
            cell.eventLocaiton.text = event.location_name
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mandEventCell", for: indexPath) as! MandCollectionViewCell
            
            let event = events[indexPath.row]
            
            
            cell.eventName.text = event.name
            cell.eventTime.text = event.start_time + " - " + event.end_time
            cell.eventLocation.text = event.location_name
            //cell.eventImage.image = UIImage(named: "recommEvent")
            
            //        cell.eventName.text = testEventNames[indexPath.row]
            //        cell.eventTime.text = testEventTimes[indexPath.row]
            //        cell.eventLocation.text = testEventLocations[indexPath.row]
            //        cell.eventImage.image = UIImage(named: "recommEvent")
            
            cell.contentView.layer.cornerRadius = 5.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
            
            return cell
            
        }
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
    
       
       //mandCollectionView.reloadData()
       recomCollectionView.reloadData()
       allEventsCollectionView.reloadData()
        //recomCollectionView.reloadData()
        //allEventsTableView.reloadData()
        //self.collectionView.reloadData()
        
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
        getEventData(url:APICLIENT_URL)
        for event in events{
            for tag in event.tags{
                if userTags.contains(tag){
                    recom_events.append(event)
                    break
                }
            }
        }
    }

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
        
        if collectionView == self.allEventsCollectionView{
            let event = events[indexPath.row]
            DvC.getName = event.name
            DvC.getTime = event.start_time + " - " + event.end_time
            DvC.getLocation = event.location_name
            DvC.getDescription = event.description
            
            
        } else if collectionView == self.recomCollectionView{
            let event = recom_events[indexPath.row]
            DvC.getName = event.name
            DvC.getTime = event.start_time + " - " + event.end_time
            DvC.getLocation = event.location_name
            DvC.getDescription = event.description
            
        } else {
            let event = events[indexPath.row]
            DvC.getName = event.name
            DvC.getTime = event.start_time + " - " + event.end_time
            DvC.getLocation = event.location_name
            DvC.getDescription = event.description
        }
        self.navigationController?.pushViewController(DvC, animated: true)
    }
    
}
