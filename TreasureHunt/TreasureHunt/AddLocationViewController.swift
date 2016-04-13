//
//  AddLocationViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 11/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
//import CoreData
import MapKit
import CoreLocation
import CloudKit


class AddLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var locationTextField: UILabel!
    @IBOutlet weak var MyLocationView: MKMapView!
    
    @IBOutlet weak var summaryTextField: UITextField!
    
    var newItem:Location? = nil
   // var locationArray : [Location] = []
//    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//    
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
        if summaryTextField.text == "" {
            return
        }
        let identifier = NSUUID().UUIDString //format cle unique
        let locID = CKRecordID(recordName : identifier)
        let locRecord = CKRecord(recordType: "Location", recordID: locID)
        locRecord.setObject(summaryTextField.text, forKey: "summary")
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase		// iclou.iblur.Demo
        
        publicDatabase.saveRecord(locRecord, completionHandler: { (record, error) -> Void in
            if (error != nil) {
                print(error)
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
               // self.viewWait.hidden = true
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            })
        })
    }
    
    
    
}




// coreData
//                if newItem == nil
//        {
//            let context = self.context
//            let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: context)
//
//            let loc = NSManagedObject(entity:  entity!,insertIntoManagedObjectContext: context)
//            let lat = locationManager.location?.coordinate.latitude
//            let long = locationManager.location?.coordinate.longitude
//            loc.setValue(self.locationTextField.text, forKey: "summary")
//            loc.setValue(lat, forKey: "lattitude")
//            loc.setValue(long, forKey: "longitude")
//            locationTextField.text = ("\(lat) & \(long)")
//                print("\(lat!) & \(long!)")
//            do{
//                try context.save()
//                //5
//                
//            } catch let error as NSError  {
//                print("Could not save \(error), \(error.userInfo)")
//            }
//        }
//        
//}


//            let newItem = Location(entity: entity!, insertIntoManagedObjectContext: context)
//            newItem.summary = summaryTextField.text!
//
//            do {
//                //try context.save()
//                try newItem.managedObjectContext?.save()
//            } catch _ {
//            }
//        } else {
//
//            newItem!.summary = summaryTextField.text!
//
//            do {
//                //try context.save()
//                try newItem!.managedObjectContext?.save()
//            } catch _ {
//            }
//        }
//
//        navigationController!.popViewControllerAnimated(true)
//



/*
 // MARK: - Navigatio n
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


