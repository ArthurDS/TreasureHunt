//
//  CreateOwnGameTableViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 19/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
import MapKit
import CloudKit
import QuartzCore
import FillableLoaders
import CoreLocation

class CreateOwnGameTableViewController: UITableViewController, addQuestionViewControllerDelegatee,CLLocationManagerDelegate{
    let locationManager = LocationManager.sharedManager
    
    @IBOutlet weak var idGameField: UITextField!
    @IBOutlet weak var cameraRollButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    //var unikIdGame : CKRecord! = nil
    
    var imageURL: NSURL?
    var currentFilter: CIFilter!
    var context: CIContext!
    let tempImageName = "temp_image.jpg"
    let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] //as NSString
    var alert : UIAlertController!
    var riddleArray : [CKRecord] = []
    var gameArray : [CKRecord] = []
    //var lastId : Int!
    var gameSelected : CKRecord!
    //var gameIdent : Int!
    var riddleArrayByIDGame: [CKRecord] = []
    var number: Int32! = nil
    var myLocation : CLLocationCoordinate2D!
   // let location = CLLocationManager()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        

        fetchAllGames()
        fetchAllRiddlesPerID()
        addGameTitleAlert()
        context = CIContext(options: nil)
        currentFilter = CIFilter(name: "CISepiaTone")
        //searchAllRiddlesForIdGame()
       // lastId = gameArray.count
        //print("count element \(lastId)")
        navigationController?.navigationBarHidden = false
        //let idGame : Int
        //gameIdent = Int(idGameField.text!)
        
    }
    
    func searchAllRiddlesForIdGame(){
//       // let idGame = gameSelected.valueForKey("id_Game") as? Int
//        
//        
//        for record in riddleArray{
//            
//            if record.valueForKey("id_Riddle") as? Int == idGame {
//                riddleArrayByIDGame.append(record)
//                
//            }
//           // print(riddleArray.count)
//        }
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // if (let gameIdent ==
        return riddleArrayByIDGame.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GameID", forIndexPath: indexPath) as! CreateRiddleTableViewCell
        let identifier = NSUUID().UUIDString //format cle unique
        let gameID = CKRecordID(recordName : identifier)
        let gameRecord = CKRecord(recordType: "Game", recordID: gameID)
        
        let riddleRecord: CKRecord = riddleArrayByIDGame[indexPath.row]
        let riddleTitle = riddleRecord.valueForKey("nameLocation") as? String
       // print(riddleTitle)
        let idGame = gameSelected.valueForKey("id_Game") as? Int

        
        for _ in riddleArrayByIDGame {
            let idRiddle = riddleRecord.valueForKey("id_Riddle") as? Int
            if (idGame == idRiddle){
                cell.locationLabel.text = riddleTitle            }
        }
        
        return cell
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
        alert = UIAlertController(title: "         Ms Hudson:", message: "                           Before we can create a\n                    game, we need a snazzy title.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let yourImage = UIImage(named: "hudson2")
        let imageView = UIImageView(frame: CGRectMake(-20,-10, 140, 115))
        imageView.image = yourImage
        alert.view.addSubview(imageView)
        
        let confirmAction = UIAlertAction(title: "Did it!", style: .Default) { (_) in
            if let field = self.alert.textFields![0] as? UITextField {
                // store your data
                NSUserDefaults.standardUserDefaults().setObject(field.text, forKey: "")
                NSUserDefaults.standardUserDefaults().synchronize()
                let newGame = String(self.alert.textFields![0].text!)
              //  print("the game is  ******************************\(newGame)")
                
                
                self.title = newGame
                // save  title in game in CK
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { action in self.performSegueWithIdentifier("goToStartSegue", sender: self) })
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Game Title"
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        alert.view.tintColor = UIColor(red: 0.582, green: 0.4196, blue: 0, alpha: 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
//    func countIdGame()-> Int{
//        var countRecord = 0
//        
//        for record in gameArray {
//            gameArray.append(record)
//            let countRecord = countRecord + 1
//        }
//        return countRecord
//    }
    var cameraUI: UIImagePickerController! = UIImagePickerController()
    
    @IBAction func PresentCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func PickpictureFromCameraRoll(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func saveData(sender: AnyObject) {
        let identifier = NSUUID().UUIDString //format cle unique
        let gameID = CKRecordID(recordName : identifier)
        let gameRecord = CKRecord(recordType: "Game", recordID: gameID)
        let newGame = String(alert.textFields![0].text!)
        
        gameRecord.setObject(newGame, forKey: "title")
        //save foto game in CK
        // set Image in CK
        if let url = self.imageURL {
            let imageAsset = CKAsset(fileURL: url)
            gameRecord.setValue(imageAsset, forKey: "photo")//imageAsset, forKey: "photo")
            //print("asset file url before: \(imageAsset.fileURL)")
        }
        
        
        // save idGame
        //gameRecord.setValue(lastId + 1 , forKey: "id_Game")
        //gameRecord.setValue(Int(idGameField.text!), forKey: "id_Game")
        //        let recordID = CKRecordID()
        //        unikIdGame = CKRecord(recordType: "Game", recordID:  recordID)
        //        let a = unikIdGame.description
        //        print("*************************  +\(a)")
        //save unik id_Game
        
        number = Int32(arc4random() % 1000000)
        gameRecord.setValue(Int(number), forKey: "id_Game")
        //add Location

        print("========================\(locationManager.userLocation)")
//        let latitudeUser  = LocationManager.sharedManager.userLocation!.coordinate.longitude
//
//        let longitudeUser  = LocationManager.sharedManager.userLocation!.coordinate.longitude
//
//         myLocation = CLLocationCoordinate2D(latitude: latitudeUser,longitude: longitudeUser)

        
        

        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase		// iclou.iblur.Demo
        
        
        publicDatabase.saveRecord(gameRecord, completionHandler: { (record, error) -> Void in
            if (error != nil) {
                print(error)
            }
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            })
        })
    }
    
    func saveImageLocally() { //om een file aanmaken
        
        let imageData: NSData = UIImageJPEGRepresentation(gameImage.image!, 0.8)!
        let path = documentsDirectoryPath.stringByAppendingString("/" + tempImageName)
        
        imageURL = NSURL(fileURLWithPath: path)
        imageData.writeToURL(imageURL!, atomically: true)
        
        cameraRollButton.hidden = true
        takePhotoButton.hidden = true

        
    }
    //    func numberOfGames() -> Int {
    //        var nb : Int = 0
    //        for record in gameArray{
    //            nb += 1
    //
    //        }
    //        return nb
    //    }
    
    //segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToDetail" {
            let nav = segue.destinationViewController as!UINavigationController
            let createGameController = nav.viewControllers.first as! CreateOwnGameDetailsViewController
            
            createGameController.delegate = self
            //let idGame = Int(self.idGameField.text!)
            let idGame = Int32(self.number)
            createGameController.idGameForRiddle = idGame
        }
    }
    
    
    func fetchAllGames() {
        
        
        
        //Games opvragen
        
        let container = CKContainer.defaultContainer()
        
        let publicDatabase = container.publicCloudDatabase
        
        let predicate = NSPredicate(value: true) // used to filter: true -> show all
        
        
        
        let query = CKQuery(recordType: "Game", predicate: predicate)//maak een cloudKit Query
        
        
        
        publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error != nil {
                
                print(error)
                
            }
                
            else {
                
                print(results)
                
                self.gameArray = results!
                // self.locArray.append(results)
                
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    // completionHandler(records: results, error: error)
                    self.tableView.reloadData()
                })
                
            }
            
            
        }
    }


func fetchAllRiddlesPerID() {
    
    
    
    //Games opvragen
    
    let container = CKContainer.defaultContainer()
    
    let publicDatabase = container.publicCloudDatabase
    
    let predicate = NSPredicate(value: true) // used to filter: true -> show all
    
    
    
    let query = CKQuery(recordType: "Riddles", predicate: predicate)//maak een cloudKit Query
    
    
    
    publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
        if error != nil {
            
            print(error)
            
        }
            
        else {
            
            print(results)
                       self.riddleArray = results!
            // self.locArray.append(results)
            
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                // completionHandler(records: results, error: error)
                                self.tableView.reloadData()
                                self.searchAllRiddlesForIdGame()


            })
            
        }
        
        
    }
}
    
    
    
}


extension CreateOwnGameTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        gameImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        gameImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imageContentMode = UIViewContentMode.ScaleAspectFit
        saveImageLocally()
        
        let beginImage = CIImage(image: newImage!)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        gameImage.hidden = false
        
        
        dismissViewControllerAnimated(true, completion: nil)
        applyProcessing()
        
    }
    
    func applyProcessing() {
        
        let cgimg = context.createCGImage(currentFilter.outputImage!, fromRect: currentFilter.outputImage!.extent)
        let processedImage = UIImage(CGImage: cgimg)
        
        gameImage.image = processedImage
    }
}
