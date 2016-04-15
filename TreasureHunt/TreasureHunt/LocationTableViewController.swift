//
//  LocationTableViewTableViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 11/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
//import CoreData
import CloudKit

class LocationTableViewTableViewController: UITableViewController{
//NSFetchedResultsControllerDelegate {
    
    let locationManager = LocationManager.sharedManager
    var locArray: [CKRecord] = []
    
    
    
    
    

    //var managedObjectContext : NSManagedObjectContext!//(UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    //var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()


    override func viewDidLoad() {
        super.viewDidLoad()
         fetchLocation()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  self.locArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! LocationTableViewCell
        let locRecord : CKRecord = locArray[indexPath.row]
        print("*****************\(locRecord)")
        cell.descriptionLabel.text = locRecord.valueForKey("summary") as? String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy, hh:mm"
        cell.datumLabel.text = dateFormatter.stringFromDate(locRecord.valueForKey("timestamp") as! NSDate)
        cell.uploadedPictureImageView?.image = locRecord.valueForKey("photo") as? UIImage
        
        return cell
    }
    
    
    func fetchLocation() {//location opvragen
        
        let container = CKContainer.defaultContainer()
        
        let publicDatabase = container.publicCloudDatabase
        
        let predicate = NSPredicate(value: true) //
        
        
        
        let query = CKQuery(recordType: "Location", predicate: predicate)//maak een cloudKit Query
        
        
        
        publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            
            if error != nil {
                
                print(error)
                
            }
                
            else {
                
                print("==================\(results)")
                
                self.locArray = results!
                
                // self.arrNotes.append(result as! CKRecord)
                
                
                
                
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                    self.tableView.reloadData()
                    
                    self.tableView.hidden = false
                    
                })
                
            }
            
        }
        
        
        
    }
    

 
        /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//            let indexPath = self.tableView.indexPathForSelectedRow
//            let locRecord : CKRecord = locArray[indexPath!.row]
//            let userLatitude = locRecord.valueForKey("lattitude") as? Double
//            let userLongitude = locRecord.valueForKey("longitude") as? Double
//            let detailViewController = segue.destinationViewController as! LocationDetailTableViewController
//
//    
//        }
    


}
