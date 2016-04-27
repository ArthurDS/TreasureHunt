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
    
    var riddlesSolvedArray: [String] = []
    var riddlesSolvedWrongArray: [String] = []
    
    var gameIsPlayed: [Int] = []

    private override init() {
        super.init()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            self.userLocation = locationManager.location
        }
    }
    
    func addGameInfo(title: String, completionHandler: (record: CKRecord?, error: NSError?) -> Void) {
        
        let identifier = NSUUID().UUIDString
        let gameID = CKRecordID(recordName: identifier)
        let gameRecord = CKRecord(recordType: "Game", recordID: gameID)
        
        gameRecord.setObject(title, forKey: "title")
    }
//    func lastIdGame(){
//        let identifier = NSUUID().UUIDString
//        let gameID = CKRecordID(recordName: identifier)
//        let gameRecord = CKRecord(recordType: "Game", recordID: gameID)
//         for record in
//        
//    }
    
    func addLocation(uniqueRiddleID: Int, summary: String, imageURL: NSURL?, completionHandler: (record: CKRecord?, error: NSError?) -> Void) {
        
        // Universal Unique Identifier (e.g. social security number)
        let identifier = NSUUID().UUIDString //format cle unique
        let locID = CKRecordID(recordName : identifier)
        let locRecord = CKRecord(recordType: "Riddles", recordID: locID)
        
        locRecord.setObject(summary, forKey: "summary")
        locRecord.setObject(uniqueRiddleID, forKey: "UniqueRiddleID")
        
        let loc = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        locRecord.setObject(loc, forKey: "location")
        
        if let url = imageURL {
            let imageAsset = CKAsset(fileURL: url)
            locRecord.setObject(imageAsset, forKey: "photo")
        }
        
        locRecord.setObject(NSDate(), forKey: "timestamp")
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
    
    func addClues(uniqueClueID: Int, clue_ID: Int, clueImageURL: NSURL?, completionHandler: (record: CKRecord?, error: NSError?) -> Void) {
        
        let identifier = NSUUID().UUIDString
        let clueID = CKRecordID(recordName: identifier)
        let clueRecord = CKRecord(recordType: "Clues", recordID: clueID)
        
        clueRecord.setObject(clue_ID, forKey: "id_clue")
        clueRecord.setObject(uniqueClueID, forKey: "UniqueClueID")
        
        if let url = clueImageURL {
            let imageAsset = CKAsset(fileURL: url)
            clueRecord.setObject(imageAsset, forKey: "photo_clue")
        }
        
        
        
    }
    
    func fetchAllLocations(completionHandler: (records: [CKRecord]?, error: NSError?) -> Void) {
        
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
    
    func fetchClues(completionHandler: (records: [CKRecord]?, error: NSError?) -> Void) {
        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Clues", predicate: predicate)
        
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

