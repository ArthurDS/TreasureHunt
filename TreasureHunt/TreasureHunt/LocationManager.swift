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
import FillableLoaders

let LocationManagerDidAddLocation = "LocationManagerDidAddLocation"

let LocationManagerDidUpdateLocation = "locationManagerDidUpdateLocation"



class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedManager = LocationManager()
    
    var locationManager: CLLocationManager!
    
    var userLocation: CLLocation!
    

    
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
    
    func addGameInfo(title: String, completionHandler: (record: CKRecord?, error: NSError?) -> Void) {
        
        var starPath = UIBezierPath()
        starPath.moveToPoint(CGPointMake(180, 25))
        starPath.addLineToPoint(CGPointMake(195.16, 43.53))
        starPath.addLineToPoint(CGPointMake(220.9, 49.88))
        starPath.addLineToPoint(CGPointMake(204.54, 67.67))
        starPath.addLineToPoint(CGPointMake(205.27, 90.12))
        starPath.addLineToPoint(CGPointMake(180, 82.6))
        starPath.addLineToPoint(CGPointMake(154.73, 90.12))
        starPath.addLineToPoint(CGPointMake(155.46, 67.67))
        starPath.addLineToPoint(CGPointMake(139.1, 49.88))
        starPath.addLineToPoint(CGPointMake(164.84, 43.53))
        starPath.closePath()
        UIColor.grayColor().setFill()
        starPath.fill()
        
        let myPath = starPath.CGPath
        var loader = WavesLoader.showProgressBasedLoaderWithPath(myPath)
        
        
        loader.showLoader()
        
        let identifier = NSUUID().UUIDString
        let gameID = CKRecordID(recordName: identifier)
        let gameRecord = CKRecord(recordType: "Game", recordID: gameID)
        
        gameRecord.setObject(title, forKey: "title")
        
        loader.removeLoader()
    }
    
    func addLocation(summary summary: String, imageURL: NSURL?, completionHandler: (record: CKRecord?, error: NSError?) -> Void) {
        
        // Universal Unique Identifier (e.g. social security number)
        let identifier = NSUUID().UUIDString //format cle unique
        let identifier2 = NSUUID().UUIDString
        let locID = CKRecordID(recordName : identifier)
        let answID = CKRecordID(recordName: identifier2)
        let locRecord = CKRecord(recordType: "Riddles", recordID: locID)
        let gameRecord = CKRecord(recordType: "Game",recordID: answID)
        
        // set summary in CK
        
        locRecord.setObject(summary, forKey: "summary")
        
        let loc = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        locRecord.setObject(loc, forKey: "location")
        // set Image in CK
        if let url = imageURL {
            let imageAsset = CKAsset(fileURL: url)
            locRecord.setObject(imageAsset, forKey: "photo")
            
        }
        
        //timeStamp in CK
        locRecord.setObject(NSDate(), forKey: "timestamp")
      //  gameRecord.setObject(, forKey: <#T##String#>)
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase		// iclou.iblur.Demo
        //rel tussen de entities
        
       // locRecord.setObject(CKReference(recordID: locID , action: CKReferenceAction.None), forKey: "answer")
        //gameRecord.setObject(CKReference(recordID: answID,action: CKReferenceAction.None), forKey: "riddle")
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
    
    func fetchAllLocations(completionHandler: (records: [CKRecord]?, error: NSError?) -> Void) {
        

        
        //Riddles opvragen
        
        let container = CKContainer.defaultContainer()
        
        let publicDatabase = container.publicCloudDatabase
        
        let predicate = NSPredicate(value: true) // used to filter: true -> show all
        
        
        
        let query = CKQuery(recordType: "Riddles", predicate: predicate)//maak een cloudKit Query
        
        
        
        publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completionHandler(records: results, error: error)
                })
            
        }
        

    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        
        
        self.userLocation = locations.last
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let notification = NSNotification(name: LocationManagerDidUpdateLocation, object: self)
        notificationCenter.postNotification(notification)
        
        
        
    }
    
    
    func isNearRecord(record: CKRecord) -> Bool {
        
        guard userLocation != nil else {
            return false
        }
     
        let recordLocation = record["location"] as! CLLocation
        
        let distance = userLocation.distanceFromLocation(recordLocation)
        
        let result = distance < 20 ? true : false
        
        
        return result
        
        }
}


