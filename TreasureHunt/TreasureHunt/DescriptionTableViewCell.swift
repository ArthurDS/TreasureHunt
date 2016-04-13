//
//  DescriptionTableViewCell.swift
//  TreasureHunt
//
//  Created by Jean Smits on 11/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
import CoreLocation


class DescriptionTableViewCell: UITableViewCell {
    
    let locationManager = LocationManager.sharedManager
    var location: Location!

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    
    
    @IBOutlet weak var distanceTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        
        let latestLocation: AnyObject = locations[locations.count - 1]
        
        let getLat: CLLocationDegrees = latestLocation.coordinate.latitude
        let getLon: CLLocationDegrees = latestLocation.coordinate.longitude
        
        let getMovedMapCenter: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
        
        let myBuddysLocation = CLLocation(latitude: 50.881581, longitude: 4.711865)
        let distances = getMovedMapCenter.distanceFromLocation(myBuddysLocation) / 1000
        
        distanceTextField.text = String(format: " %.01fkm", distances)
        
        
    }
    
}
