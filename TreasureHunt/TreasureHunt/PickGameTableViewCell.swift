//
//  PickGameTableViewCell.swift
//  TreasureHunt
//
//  Created by Jean Smits on 21/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit

class PickGameTableViewCell: UITableViewCell {

    @IBOutlet weak var justALine: UIView!
    @IBOutlet weak var pickGameEpisodeNumberLabel: UILabel!
    @IBOutlet weak var pickGameEpisodeLabel: UILabel!
    @IBOutlet weak var pickGameLabel: UILabel!
    @IBOutlet weak var pickGameImage: UIImageView!
    @IBOutlet weak var pickGameBackground: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
