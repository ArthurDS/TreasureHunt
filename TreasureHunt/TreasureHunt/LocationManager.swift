//
//  LocationManager.swift
//  TreasureHunt
//
//  Created by Jean Smits on 11/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
import CoreLocation


class LocationManager: NSObject ,CLLocationManagerDelegate{
    
static let sharedManager = LocationManager()
    private let locationManager = CLLocationManager()
    
    private(set) var currentLocation = CLLocationCoordinate2D(latitude:0, longitude: 0)
    
    private override init() {
        
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.NotDetermined) {
            locationManager.requestAlwaysAuthorization()
        }

        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        self.currentLocation = newLocation.coordinate
    }

    
     

}
