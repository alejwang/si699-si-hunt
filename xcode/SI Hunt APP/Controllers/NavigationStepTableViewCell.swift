//
//  navigationStepTableViewCell.swift
//  ARKitImageRecognition
//
//  Created by Alejandro Wang on 4/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class NavigationStepTableViewCell: UITableViewCell {

    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var stepLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
