
//
//  RiddleTableViewCell.swift
//  TreasureHunt
//
//  Created by Jean Smits on 19/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit

class RiddleTableViewCell: UITableViewCell {

    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var signRight: UIImageView!
    @IBOutlet weak var signLeft: UIImageView!
    
    @IBOutlet weak var mistyLayer: UIView!
    @IBOutlet weak var riddleCellBackground: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
