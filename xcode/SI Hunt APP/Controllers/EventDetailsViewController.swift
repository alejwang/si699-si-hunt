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

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
