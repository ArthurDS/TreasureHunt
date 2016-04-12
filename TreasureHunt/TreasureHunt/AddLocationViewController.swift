//
//  AddLocationViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 11/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation


class AddLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var locationTextField: UILabel!
    @IBOutlet weak var MyLocationView: MKMapView!
    
    @IBOutlet weak var summaryTextField: UITextField!
    
    var newItem:Location? = nil
    
      let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var locationManager: CLLocationManager!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadAnnotations()
    }
    
    func loadAnnotations() {
        self.MyLocationView.removeAnnotations(self.MyLocationView.annotations)
        
            }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.MyLocationView.setRegion(region, animated: true)
    }

    


    
    @IBAction func addLocationButton(sender: AnyObject) {
        if newItem == nil
        {
            let context = self.context
            let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: context)
            
            let newItem = Location(entity: entity!, insertIntoManagedObjectContext: context)
            newItem.summary = summaryTextField.text!
            
            do {
                //try context.save()
                try newItem.managedObjectContext?.save()
            } catch _ {
            }
        } else {
            
            newItem!.summary = summaryTextField.text!
           
            do {
                //try context.save()
                try newItem!.managedObjectContext?.save()
            } catch _ {
            }
        }
        
        navigationController!.popViewControllerAnimated(true)
        
        
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


