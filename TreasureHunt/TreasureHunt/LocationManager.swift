//
//  LocationManager.swift
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
import MobileCoreServices
import QuartzCore

let LocationManagerDidAddLocation = "LocationManagerDidAddLocation"

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedManager = LocationManager()
    
    var locationManager: CLLocationManager!
    
    private override init() {
        super.init()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func addLocation(summary summary: String, imageURL: NSURL?, completionHandler: (record: CKRecord?, error: NSError?) -> Void) {
        
        // Universal Unique Identifier (e.g. social security number)
        let identifier = NSUUID().UUIDString //format cle unique
        let locID = CKRecordID(recordName : identifier)
        
        let locRecord = CKRecord(recordType: "Location", recordID: locID)
        
        // set summary in CK
        locRecord.setObject(summary, forKey: "summary")
        
        // set latitude en longitude in CK
        locRecord.setObject(locationManager.location?.coordinate.latitude, forKey: "lattitude")
        locRecord.setObject(locationManager.location?.coordinate.longitude, forKey: "longitude")
        
        // set Image in CK
        if let url = imageURL {
            let imageAsset = CKAsset(fileURL: url)
            locRecord.setObject(imageAsset, forKey: "photo")
        }
        
        //timeStamp in CK
        locRecord.setObject(NSDate(), forKey: "timestamp")
        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase		// iclou.iblur.Demo
        
        
        publicDatabase.saveRecord(locRecord, completionHandler: { (record, error) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                completionHandler(record: record, error: error)
                
                if error == nil {
                    let notificationCenter = NSNotificationCenter.defaultCenter()
                    // name -> globale let string
                    // object -> self
                    // userinfo -> dictionary met info (e.g. locRecord)
                    let notification = NSNotification(name: LocationManagerDidAddLocation, object: self, userInfo: ["record" : locRecord])
                    
                    notificationCenter.postNotification(notification)
                }
            })
        })
    }
    
}


