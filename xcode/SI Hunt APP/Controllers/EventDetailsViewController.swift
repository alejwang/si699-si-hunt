//
//  EventDetailsViewController.swift
//  ARKitImageRecognition
//
//  Created by Yi-Chen Weng on 4/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    var getImage = UIImage()
    var getName = String()
    var getTime = String()
    var getLocation = String()
    var getDescription = String()

    var eventId = Int()
    var eventlocationName = String()

    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        eventImage.image = getImage
        eventName.text = getName
        eventTime.text = getTime
        eventLocation.text = getLocation
        eventDescription.text = getDescription
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "startNavigation" {
            //print(indexPathforDetail![1])
            let navVC = segue.destination as! ViewController
            navVC.eventlocationName = eventlocationName
            navVC.eventId = eventId
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

}
