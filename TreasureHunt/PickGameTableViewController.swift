//
//  PickGameTableViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 21/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
import CloudKit
import FillableLoaders

class PickGameTableViewController: UITableViewController {
        let locationManager = LocationManager.sharedManager
    var gameArray: [CKRecord] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = false

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundView = UIImageView(image: UIImage(named: "woodboard"))

         fetchGame()
        fetchLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        print(self.locationManager.gameIsPlayed)
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameArray.count
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pickGameID", forIndexPath: indexPath) as! PickGameTableViewCell
        
        let gameRecord: CKRecord = gameArray[indexPath.row]
        let gameTitle = gameRecord.valueForKey("title")
        print(gameTitle)
        
        let img = gameRecord.valueForKey("photo") as? CKAsset
        cell.pickGameImage.image = UIImage(contentsOfFile: img!.fileURL.path!)
        
        cell.pickGameImage?.contentMode = UIViewContentMode.ScaleToFill
        
        
        let indexValue : String = String(format: "%d", indexPath.row + 1)
        
        
        cell.pickGameLabel.text = gameTitle as? String
        cell.pickGameEpisodeNumberLabel.text = indexValue
        
        let gameID = gameRecord.valueForKey("id_Game") as? Int
        
        for game in self.gameArray {
            
           for game in self.locationManager.gameIsPlayed {
                if game == gameID! {
                    cell.finishedLabel.alpha = 1
                }
                else {
                    continue
                }

            }
        }
        return cell
    }
    
    func fetchLocation() {//location opvragen
        
        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true) //
        let query = CKQuery(recordType: "Riddles", predicate: predicate)//maak een cloudKit Query
        
        publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error != nil {
                print(error)
            }
            else {

                
                print(results)
                
                self.locationManager.riddleArrayByIdGame = results!
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.tableView.hidden = false
                    self.tableView.reloadData()
                    

                    

        
                    
                    
                })
            }
        }
    }

    
    
    
    func fetchGame() {
        
        let bezier2Path = UIBezierPath()
        bezier2Path.moveToPoint(CGPoint(x: 170.47, y: 11.16))
        bezier2Path.addCurveToPoint(CGPoint(x: 178.48, y: 21.74), controlPoint1: CGPoint(x: 170.47, y: 11.16), controlPoint2: CGPoint(x: 176.24, y: 18.78))
        bezier2Path.addCurveToPoint(CGPoint(x: 187.54, y: 25.24), controlPoint1: CGPoint(x: 181.62, y: 22.24), controlPoint2: CGPoint(x: 184.7, y: 23.4))
        bezier2Path.addCurveToPoint(CGPoint(x: 193.99, y: 31.48), controlPoint1: CGPoint(x: 190.15, y: 26.94), controlPoint2: CGPoint(x: 192.31, y: 29.08))
        bezier2Path.addCurveToPoint(CGPoint(x: 204.9, y: 32.6), controlPoint1: CGPoint(x: 197.62, y: 31.85), controlPoint2: CGPoint(x: 204.9, y: 32.6))
        bezier2Path.addCurveToPoint(CGPoint(x: 198.04, y: 42.09), controlPoint1: CGPoint(x: 204.9, y: 32.6), controlPoint2: CGPoint(x: 199.96, y: 39.43))
        bezier2Path.addCurveToPoint(CGPoint(x: 194.41, y: 57.76), controlPoint1: CGPoint(x: 198.69, y: 47.38), controlPoint2: CGPoint(x: 197.55, y: 52.93))
        bezier2Path.addCurveToPoint(CGPoint(x: 190.47, y: 62.39), controlPoint1: CGPoint(x: 193.28, y: 59.51), controlPoint2: CGPoint(x: 191.94, y: 61.05))
        bezier2Path.addCurveToPoint(CGPoint(x: 193, y: 77), controlPoint1: CGPoint(x: 192.09, y: 66.77), controlPoint2: CGPoint(x: 193, y: 71.74))
        bezier2Path.addCurveToPoint(CGPoint(x: 192.95, y: 79.03), controlPoint1: CGPoint(x: 193, y: 77.68), controlPoint2: CGPoint(x: 192.98, y: 78.36))
        bezier2Path.addCurveToPoint(CGPoint(x: 193, y: 81.64), controlPoint1: CGPoint(x: 193, y: 79.73), controlPoint2: CGPoint(x: 193, y: 80.55))
        bezier2Path.addLineToPoint(CGPoint(x: 193, y: 101.36))
        bezier2Path.addCurveToPoint(CGPoint(x: 192.67, y: 105.65), controlPoint1: CGPoint(x: 193, y: 103.56), controlPoint2: CGPoint(x: 193, y: 104.66))
        bezier2Path.addLineToPoint(CGPoint(x: 192.63, y: 105.84))
        bezier2Path.addCurveToPoint(CGPoint(x: 189.84, y: 108.63), controlPoint1: CGPoint(x: 192.15, y: 107.14), controlPoint2: CGPoint(x: 191.14, y: 108.15))
        bezier2Path.addCurveToPoint(CGPoint(x: 185.36, y: 109), controlPoint1: CGPoint(x: 188.66, y: 109), controlPoint2: CGPoint(x: 187.56, y: 109))
        bezier2Path.addLineToPoint(CGPoint(x: 154.64, y: 109))
        bezier2Path.addCurveToPoint(CGPoint(x: 150.35, y: 108.67), controlPoint1: CGPoint(x: 152.44, y: 109), controlPoint2: CGPoint(x: 151.34, y: 109))
        bezier2Path.addLineToPoint(CGPoint(x: 150.16, y: 108.63))
        bezier2Path.addCurveToPoint(CGPoint(x: 149.33, y: 108.23), controlPoint1: CGPoint(x: 149.87, y: 108.52), controlPoint2: CGPoint(x: 149.59, y: 108.39))
        bezier2Path.addCurveToPoint(CGPoint(x: 141.43, y: 108.94), controlPoint1: CGPoint(x: 147.47, y: 108.4), controlPoint2: CGPoint(x: 144.92, y: 108.63))
        bezier2Path.addCurveToPoint(CGPoint(x: 124.57, y: 88.98), controlPoint1: CGPoint(x: 128.49, y: 110.11), controlPoint2: CGPoint(x: 124.57, y: 88.98))
        bezier2Path.addCurveToPoint(CGPoint(x: 136.79, y: 57.36), controlPoint1: CGPoint(x: 124.57, y: 88.98), controlPoint2: CGPoint(x: 119.67, y: 67.95))
        bezier2Path.addCurveToPoint(CGPoint(x: 140.41, y: 63.78), controlPoint1: CGPoint(x: 153.44, y: 47.07), controlPoint2: CGPoint(x: 141.1, y: 62.91))
        bezier2Path.addCurveToPoint(CGPoint(x: 130.55, y: 88.44), controlPoint1: CGPoint(x: 139.65, y: 64.2), controlPoint2: CGPoint(x: 128.89, y: 70))
        bezier2Path.addCurveToPoint(CGPoint(x: 147, y: 101.3), controlPoint1: CGPoint(x: 131.63, y: 100.48), controlPoint2: CGPoint(x: 140.56, y: 101.89))
        bezier2Path.addCurveToPoint(CGPoint(x: 147, y: 81.64), controlPoint1: CGPoint(x: 147, y: 100.16), controlPoint2: CGPoint(x: 147, y: 81.64))
        bezier2Path.addCurveToPoint(CGPoint(x: 147.04, y: 78.99), controlPoint1: CGPoint(x: 147, y: 80.52), controlPoint2: CGPoint(x: 147, y: 79.68))
        bezier2Path.addCurveToPoint(CGPoint(x: 147, y: 77), controlPoint1: CGPoint(x: 147.01, y: 78.33), controlPoint2: CGPoint(x: 147, y: 77.67))
        bezier2Path.addCurveToPoint(CGPoint(x: 150.25, y: 60.59), controlPoint1: CGPoint(x: 147, y: 71), controlPoint2: CGPoint(x: 148.19, y: 65.39))
        bezier2Path.addCurveToPoint(CGPoint(x: 153.4, y: 54.85), controlPoint1: CGPoint(x: 151.15, y: 58.51), controlPoint2: CGPoint(x: 152.2, y: 56.58))
        bezier2Path.addCurveToPoint(CGPoint(x: 151.22, y: 45.4), controlPoint1: CGPoint(x: 152.03, y: 51.88), controlPoint2: CGPoint(x: 151.29, y: 48.66))
        bezier2Path.addCurveToPoint(CGPoint(x: 155.02, y: 32.12), controlPoint1: CGPoint(x: 151.13, y: 40.85), controlPoint2: CGPoint(x: 152.35, y: 36.22))
        bezier2Path.addCurveToPoint(CGPoint(x: 165.31, y: 23.4), controlPoint1: CGPoint(x: 157.63, y: 28.12), controlPoint2: CGPoint(x: 161.24, y: 25.17))
        bezier2Path.addCurveToPoint(CGPoint(x: 170.46, y: 11.17), controlPoint1: CGPoint(x: 166.73, y: 20.04), controlPoint2: CGPoint(x: 170.35, y: 11.43))
        bezier2Path.addLineToPoint(CGPoint(x: 170.47, y: 11.16))


        bezier2Path.closePath()
        UIColor.blackColor().setFill()
        bezier2Path.fill()

        
        let myPath = bezier2Path.CGPath
        let loader = WavesLoader.showLoaderWithPath(myPath)
        loader.loaderColor = UIColor.redColor()

        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Game", predicate: predicate)
        
        publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                loader.showLoader()
                print(results)
                self.gameArray = results!
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.tableView.hidden = false
                    self.tableView.reloadData()
                    loader.removeLoader()
                    self.locationManager.riddleArrayByIdGame = self.gameArray
                })

            }
            
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let playgameController = segue.destinationViewController as! PlayGameMapViewTableViewController
        let indexSelected = tableView.indexPathForSelectedRow
        let selectedGame = gameArray[(indexSelected?.row)!]
        
        playgameController.gameSelected = selectedGame
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
