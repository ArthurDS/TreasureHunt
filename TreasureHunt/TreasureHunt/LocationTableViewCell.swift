//
//  LocationTableViewCell.swift
//  TreasureHunt
//
//  Created by Jean Smits on 11/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var uploadedPictureImageView: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
