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

class CreateOwnGameTableViewController: UITableViewController, addQuestionViewControllerDelegatee {
    let locationManager = LocationManager.sharedManager

    @IBOutlet weak var mapView: MKMapView!
    var imageURL: NSURL?
    @IBOutlet weak var gameImage: UIImageView!
    var currentFilter: CIFilter!
    var context: CIContext!
    let tempImageName = "temp_image.jpg"
    let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] //as NSString
    var alert : UIAlertController!
    var riddleArray : CKRecord!
    var gameArray : [CKRecord] = []
    var lastId : Int!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchAllGames()
        addGameTitleAlert()
        context = CIContext(options: nil)
        currentFilter = CIFilter(name: "CISepiaTone")
        lastId = 2
        print(lastId)
        
        
       
        // var nbRecord = riddleArray.creatorUserRecordID?.recordName
        //print(lastIdGame)
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameArray.count
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
        alert = UIAlertController(title: "Catson:", message: "Before we can create a game, we need a snazzy title.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let yourImage = UIImage(named: "catson")
        var imageView = UIImageView(frame: CGRectMake(-20, -40, 100, 140))
        imageView.image = yourImage
        alert.view.addSubview(imageView)
        
        let confirmAction = UIAlertAction(title: "Did it!", style: .Default) { (_) in
            if let field = self.alert.textFields![0] as? UITextField {
                // store your data
                NSUserDefaults.standardUserDefaults().setObject(field.text, forKey: "")
                NSUserDefaults.standardUserDefaults().synchronize()
                let newGame = String(self.alert.textFields![0].text!)
                print("the game is  ******************************\(newGame)")
                
                
                self.title = newGame
                // save  title in game in CK
                
                
                
                
                
                
                
                
                
                
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
    var cameraUI: UIImagePickerController! = UIImagePickerController()
    
    @IBAction func PresentCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            //access a la libairie de ton device
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
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
            print("asset file url before: \(imageAsset.fileURL)")
        }
        
        // save idGame
        
        gameRecord.setValue(lastId + 1 , forKey: "id_Game")
        
        
        
        
        
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
        let nav = segue.destinationViewController as!UINavigationController
        let createGameController = nav.viewControllers.first as! CreateOwnGameDetailsViewController
        createGameController.delegate = self
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
