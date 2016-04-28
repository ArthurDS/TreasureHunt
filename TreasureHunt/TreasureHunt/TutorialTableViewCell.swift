//
//  TutorialTableViewCell.swift
//  TreasureHunt
//
//  Created by Jean Smits on 28/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit

class TutorialTableViewCell: UITableViewCell {

    @IBOutlet weak var tutorialTextLabel: UILabel!
    @IBOutlet weak var tutorialBackground: UIImageView!
    @IBOutlet weak var hudson: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
