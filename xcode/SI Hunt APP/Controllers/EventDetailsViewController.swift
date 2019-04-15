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
    @IBOutlet weak var navigationBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        eventImage.image = getImage
        eventName.text = getName
        eventTime.text = getTime
        eventLocation.text = getLocation
        eventDescription.text = getDescription
        
        navigationBtn.layer.cornerRadius = 16
        navigationBtn.layer.shadowColor = UIColor.gray.cgColor
        navigationBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        navigationBtn.layer.shadowOpacity = 0.5
        navigationBtn.layer.shadowRadius = 50
        navigationBtn.layer.shadowPath = UIBezierPath(roundedRect: navigationBtn.bounds, cornerRadius: 16).cgPath
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
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
}
