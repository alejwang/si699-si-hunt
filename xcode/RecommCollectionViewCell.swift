//
//  RecommCollectionViewCell.swift
//  ARKitImageRecognition
//
//  Created by Yi-Chen Weng on 4/7/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class RecommCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    
    @IBOutlet weak var imgContainer: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgContainer.layer.backgroundColor = UIColor.clear.cgColor
        imgContainer.layer.shadowColor = UIColor.gray.cgColor
        imgContainer.layer.shadowOffset = CGSize(width: 2, height: 9)
        imgContainer.layer.shadowOpacity = 0.5
        imgContainer.layer.shadowRadius = 4
        imgContainer.layer.shadowPath = UIBezierPath(roundedRect: imgContainer.bounds, cornerRadius: 20).cgPath
    }

}
