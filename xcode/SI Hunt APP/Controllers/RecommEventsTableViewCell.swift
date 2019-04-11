//
//  EventsTableViewCell.swift
//  ARKitImageRecognition
//
//  Created by Yi-Chen Weng on 4/7/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class RecommEventsTableViewCell: UITableViewCell {

//    var events = [Event]()
    
    @IBOutlet weak var recommCollectionView: UICollectionView!
//    {
//        didSet {
//            recommCollectionView.dataSource = self
//        }
//    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//            return events.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommEventsCollectionCell", for: indexPath) as! RecommCollectionViewCell
//
//        let event = events[indexPath.row]
//
//
//        cell.eventName.text = event.name
//        cell.eventTime.text = event.start_time
//        cell.eventImage.image = UIImage(named: "recommEvent")
//
//
//
//        cell.contentView.layer.cornerRadius = 5.0
//        cell.contentView.layer.borderWidth = 1.0
//        cell.contentView.layer.borderColor = UIColor.clear.cgColor
//        cell.layer.shadowColor = UIColor.gray.cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//        cell.layer.shadowRadius = 4.0
//        cell.layer.shadowOpacity = 1.0
//        cell.layer.masksToBounds = false
//        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
//
//        return cell
//    }
//
//

}
