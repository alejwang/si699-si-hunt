//
//  AllEventsTableViewCell.swift
//  ARKitImageRecognition
//
//  Created by Yi-Chen Weng on 4/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class AllEventsTableViewCell: UITableViewCell {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
