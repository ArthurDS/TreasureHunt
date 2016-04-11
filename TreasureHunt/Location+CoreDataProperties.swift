//
//  Location+CoreDataProperties.swift
//  TreasureHunt
//
//  Created by Jean Smits on 11/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var lattitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var photo: NSData?
    @NSManaged var summary: String?
    @NSManaged var timestamp: NSDate?

}
