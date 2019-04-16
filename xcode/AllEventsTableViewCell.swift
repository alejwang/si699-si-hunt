//
//  AllEventsTableViewCell.swift
//  ARKitImageRecognition
//
//  Created by Yi-Chen Weng on 4/7/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class AllEventsTableViewCell: UITableViewCell {
    
//    var events = [Event]()
    
    @IBOutlet weak var allEventsCollectionView: UICollectionView!
    @IBOutlet weak var totalEventCount: UILabel!
    //    {
//        didSet {
//            allEventsCollectionView.dataSource = self
//            allEventsCollectionView.delegate = self
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
//        return events.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllEventsCollectionCell", for: indexPath) as! AllEventsCollectionViewCell
//
//        let event = events[indexPath.row]
//
//
//        cell.eventName.text = event.name
//        cell.eventTime.text = event.start_time + " - " + event.end_time
//
//
//        return cell
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let layout = collectionViewLayout as! UICollectionViewFlowLayout
//        layout 
//    }

}
