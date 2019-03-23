//
//  EventDetailViewController.swift
//  ARKitImageRecognition
//
//  Created by Rahul Bonnerjee on 3/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    var eventDescription: String?
    var eventTitle: String?
    var eventLocation: String?
    var eventOrganizer: String?

    @IBOutlet weak var eventDetail: UILabel!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    @IBOutlet weak var eventOrganizerLabel: UILabel!
    
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventDetail.text = "Event Details: " + eventDescription!
        eventTitleLabel.text = eventTitle!
        eventOrganizerLabel.text = "Organizer: " + eventOrganizer!
        eventLocationLabel.text = "Location: " + eventLocation!
        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
