//
//  AddLocationViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 11/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class AddLocationViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var locationTextField: UILabel!
    @IBOutlet weak var MyLocationView: MKMapView!
    var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
         if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
           // self.locationTextField.text =   
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let myLocation = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        print("\(myLocation)")
    }
}
    /*
    // MARK: - Navigatio n

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


