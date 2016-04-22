//
//  CreateOwnGameTableViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 19/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
import MapKit

class CreateOwnGameTableViewController: UITableViewController, addQuestionViewControllerDelegatee {

    @IBOutlet weak var mapView: MKMapView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGameTitleAlert()
 }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func addQuestionViewControllerCancelPressedViewController(viewController: CreateOwnGameDetailsViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addQuestionViewControllerSavePressed(viewController: CreateOwnGameDetailsViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.Delete
    }
    
    func addGameTitleAlert() {
        let alert = UIAlertController(title: "Catson:", message: "                     Before we can create a\n                        game, we need a snazzy\n                       title and a game picture.", preferredStyle: UIAlertControllerStyle.Alert)
    
        let yourImage = UIImage(named: "catson")
        var imageView = UIImageView(frame: CGRectMake(-20, -40, 100, 140))
        imageView.image = yourImage
        alert.view.addSubview(imageView)

        let confirmAction = UIAlertAction(title: "Did it!", style: .Default) { (_) in
            if let field = alert.textFields![0] as? UITextField {
                // store your data
            NSUserDefaults.standardUserDefaults().setObject(field.text, forKey: "")
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Game Title"
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
     
        alert.view.tintColor = UIColor(red: 0.582, green: 0.4196, blue: 0, alpha: 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      let nav = segue.destinationViewController as!UINavigationController
        let createGameController = nav.viewControllers.first as! CreateOwnGameDetailsViewController
        createGameController.delegate = self
    }
}
