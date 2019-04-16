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
    @IBOutlet weak var navPanel: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // rewrite nav bar back btn
        // ref: https://medium.com/simple-swift-programming-tips/how-to-make-custom-uinavigationcontroller-back-button-image-without-title-swift-7ea5673d7e03
        let backButton: UIButton = UIButton (type: UIButtonType.custom)
        backButton.setImage(UIImage(named: "backButtonBlack"), for: UIControlState.normal)
        backButton.frame = CGRect(x: 0 , y: 0, width: 33, height: 32)
        backButton.addTarget(self, action: #selector(EventDetailsViewController.backButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
        

        // Do any additional setup after loading the view.
        
        eventImage.image = getImage
        eventName.text = getName
        eventTime.text = getTime
        eventLocation.text = getLocation
        eventDescription.text = getDescription
        
        let blue = UIColor(red:0.18, green:0.15, blue:0.85, alpha:0.25)
        
        navigationBtn.layer.cornerRadius = 16
        //navigationBtn.layer.shadowColor = UIColor.black.cgColor
        navigationBtn.layer.shadowColor = blue.cgColor
        navigationBtn.setTitleColor(UIColor.white, for: .normal)
        navigationBtn.layer.shadowOffset = CGSize(width: 0, height: 8)
        navigationBtn.layer.shadowOpacity = 1
        navigationBtn.layer.shadowRadius = 5
        
        
        
        navPanel.layer.cornerRadius = 16
        navPanel.layer.shadowColor = UIColor.black.cgColor
        navPanel.layer.shadowOpacity = 0.6
        navPanel.layer.shadowOffset = CGSize.zero
        navPanel.layer.shadowRadius = 8
        navPanel.layer.shadowPath = UIBezierPath(rect: navPanel.bounds).cgPath
        //navPanel.layer.shouldRasterize = true
    }
    
    // rewrite the back button action
    @objc func backButtonPressed(_ sender : Any) {
        self.navigationController?.popViewController(animated: true)
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


