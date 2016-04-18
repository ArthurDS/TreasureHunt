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
import MobileCoreServices
import QuartzCore
import FillableLoaders

class AddLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationTextField: UILabel!
    @IBOutlet weak var MyLocationView: MKMapView!
    @IBOutlet weak var summaryTextField: UITextField!
    
    let tempImageName = "temp_image.jpg"

    var imageURL: NSURL?
    
    //// Bezier Drawing
    
    
 
   

    
    let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] //as NSString

var newItem:Location? = nil
    // var locationArray : [Location] = []
    //    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    //
    var locationManager: CLLocationManager!
    var loader: WavesLoader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bezier4Path = UIBezierPath()
        bezier4Path.moveToPoint(CGPoint(x: 117.5, y: 34.56))
        bezier4Path.addCurveToPoint(CGPoint(x: 110, y: 39.82), controlPoint1: CGPoint(x: 114.11, y: 34.56), controlPoint2: CGPoint(x: 111.2, y: 36.73))
        bezier4Path.addCurveToPoint(CGPoint(x: 109.47, y: 41.96), controlPoint1: CGPoint(x: 109.74, y: 40.5), controlPoint2: CGPoint(x: 109.56, y: 41.21))
        bezier4Path.addCurveToPoint(CGPoint(x: 110.42, y: 41.52), controlPoint1: CGPoint(x: 109.77, y: 41.79), controlPoint2: CGPoint(x: 110.09, y: 41.64))
        bezier4Path.addCurveToPoint(CGPoint(x: 116.7, y: 41), controlPoint1: CGPoint(x: 112.08, y: 41), controlPoint2: CGPoint(x: 113.62, y: 41))
        bezier4Path.addLineToPoint(CGPoint(x: 118.3, y: 41))
        bezier4Path.addCurveToPoint(CGPoint(x: 124.31, y: 41.46), controlPoint1: CGPoint(x: 121.38, y: 41), controlPoint2: CGPoint(x: 122.92, y: 41))
        bezier4Path.addLineToPoint(CGPoint(x: 124.58, y: 41.52))
        bezier4Path.addCurveToPoint(CGPoint(x: 125.53, y: 41.96), controlPoint1: CGPoint(x: 124.91, y: 41.64), controlPoint2: CGPoint(x: 125.23, y: 41.79))
        bezier4Path.addCurveToPoint(CGPoint(x: 117.5, y: 34.56), controlPoint1: CGPoint(x: 125.04, y: 37.79), controlPoint2: CGPoint(x: 121.63, y: 34.56))
        bezier4Path.closePath()
        bezier4Path.moveToPoint(CGPoint(x: 117.5, y: 49))
        bezier4Path.addCurveToPoint(CGPoint(x: 115.08, y: 49.97), controlPoint1: CGPoint(x: 116.56, y: 49), controlPoint2: CGPoint(x: 115.71, y: 49.37))
        bezier4Path.addCurveToPoint(CGPoint(x: 114.74, y: 50.35), controlPoint1: CGPoint(x: 114.96, y: 50.09), controlPoint2: CGPoint(x: 114.84, y: 50.22))
        bezier4Path.addCurveToPoint(CGPoint(x: 114, y: 52.5), controlPoint1: CGPoint(x: 114.28, y: 50.94), controlPoint2: CGPoint(x: 114, y: 51.69))
        bezier4Path.addCurveToPoint(CGPoint(x: 116, y: 55.66), controlPoint1: CGPoint(x: 114, y: 53.9), controlPoint2: CGPoint(x: 114.82, y: 55.1))
        bezier4Path.addCurveToPoint(CGPoint(x: 116, y: 61), controlPoint1: CGPoint(x: 116, y: 57.73), controlPoint2: CGPoint(x: 116, y: 61))
        bezier4Path.addLineToPoint(CGPoint(x: 119, y: 61))
        bezier4Path.addCurveToPoint(CGPoint(x: 119, y: 55.66), controlPoint1: CGPoint(x: 119, y: 61), controlPoint2: CGPoint(x: 119, y: 57.73))
        bezier4Path.addCurveToPoint(CGPoint(x: 121, y: 52.5), controlPoint1: CGPoint(x: 120.18, y: 55.1), controlPoint2: CGPoint(x: 121, y: 53.9))
        bezier4Path.addCurveToPoint(CGPoint(x: 117.5, y: 49), controlPoint1: CGPoint(x: 121, y: 50.57), controlPoint2: CGPoint(x: 119.43, y: 49))
        bezier4Path.closePath()
        bezier4Path.moveToPoint(CGPoint(x: 129, y: 43))
        bezier4Path.addCurveToPoint(CGPoint(x: 128.64, y: 46), controlPoint1: CGPoint(x: 129, y: 44.04), controlPoint2: CGPoint(x: 128.87, y: 45.04))
        bezier4Path.addCurveToPoint(CGPoint(x: 129, y: 51.7), controlPoint1: CGPoint(x: 129, y: 47.46), controlPoint2: CGPoint(x: 129, y: 48.98))
        bezier4Path.addLineToPoint(CGPoint(x: 129, y: 55.3))
        bezier4Path.addCurveToPoint(CGPoint(x: 128.54, y: 61.31), controlPoint1: CGPoint(x: 129, y: 58.38), controlPoint2: CGPoint(x: 129, y: 59.92))
        bezier4Path.addLineToPoint(CGPoint(x: 128.48, y: 61.58))
        bezier4Path.addCurveToPoint(CGPoint(x: 124.58, y: 65.48), controlPoint1: CGPoint(x: 127.82, y: 63.39), controlPoint2: CGPoint(x: 126.39, y: 64.82))
        bezier4Path.addCurveToPoint(CGPoint(x: 118.3, y: 66), controlPoint1: CGPoint(x: 122.92, y: 66), controlPoint2: CGPoint(x: 121.38, y: 66))
        bezier4Path.addLineToPoint(CGPoint(x: 116.7, y: 66))
        bezier4Path.addCurveToPoint(CGPoint(x: 110.69, y: 65.54), controlPoint1: CGPoint(x: 113.62, y: 66), controlPoint2: CGPoint(x: 112.08, y: 66))
        bezier4Path.addLineToPoint(CGPoint(x: 110.42, y: 65.48))
        bezier4Path.addCurveToPoint(CGPoint(x: 106.52, y: 61.58), controlPoint1: CGPoint(x: 108.61, y: 64.82), controlPoint2: CGPoint(x: 107.18, y: 63.39))
        bezier4Path.addCurveToPoint(CGPoint(x: 106, y: 55.3), controlPoint1: CGPoint(x: 106, y: 59.92), controlPoint2: CGPoint(x: 106, y: 58.38))
        bezier4Path.addLineToPoint(CGPoint(x: 106, y: 51.7))
        bezier4Path.addCurveToPoint(CGPoint(x: 106.36, y: 46), controlPoint1: CGPoint(x: 106, y: 48.85), controlPoint2: CGPoint(x: 106, y: 47.32))
        bezier4Path.addCurveToPoint(CGPoint(x: 106, y: 43), controlPoint1: CGPoint(x: 106.13, y: 45.04), controlPoint2: CGPoint(x: 106, y: 44.04))
        bezier4Path.addCurveToPoint(CGPoint(x: 106.91, y: 38.31), controlPoint1: CGPoint(x: 106, y: 41.34), controlPoint2: CGPoint(x: 106.32, y: 39.75))
        bezier4Path.addCurveToPoint(CGPoint(x: 110.95, y: 33.13), controlPoint1: CGPoint(x: 107.77, y: 36.21), controlPoint2: CGPoint(x: 109.18, y: 34.42))
        bezier4Path.addCurveToPoint(CGPoint(x: 111.29, y: 32.9), controlPoint1: CGPoint(x: 111.06, y: 33.05), controlPoint2: CGPoint(x: 111.17, y: 32.98))
        bezier4Path.addCurveToPoint(CGPoint(x: 117.5, y: 31), controlPoint1: CGPoint(x: 113.08, y: 31.7), controlPoint2: CGPoint(x: 115.21, y: 31))
        bezier4Path.addCurveToPoint(CGPoint(x: 129, y: 43), controlPoint1: CGPoint(x: 123.85, y: 31), controlPoint2: CGPoint(x: 129, y: 36.37))
        bezier4Path.closePath()
        UIColor.grayColor().setFill()
        bezier4Path.fill()
        
        let myPath =  bezier4Path.CGPath
        
        loader = WavesLoader.createLoaderWithPath(path: myPath)
        loader.loaderColor = UIColor.greenColor()

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddLocationViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    
    
    @IBAction func addLocationButtonPressed(sender: AnyObject) {
        guard !self.summaryTextField.text!.isEmpty else {
            return
        }
        

        loader.showLoader()
        

        
        LocationManager.sharedManager.addLocation(summary: self.summaryTextField.text!, imageURL: self.imageURL, completionHandler: {(record, error) in
            
            self.loader.removeLoader()
            self.navigationController?.popViewControllerAnimated(true)
        })
    }
    
    func dismissKeyboard() {

        view.endEditing(true)
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
    
    //Add data in CK
    
    @IBAction func addLocationButton(sender: AnyObject) {
        
        if summaryTextField.text == "" {
            return
        }
        let identifier = NSUUID().UUIDString //format cle unique
        let locID = CKRecordID(recordName : identifier)
        let locRecord = CKRecord(recordType: "Location", recordID: locID)
        // set summary in CK
        locRecord.setObject(summaryTextField.text, forKey: "summary")
        // set latitude en longitude in CK
        locRecord.setObject(locationManager.location?.coordinate.latitude, forKey: "lattitude")
        locRecord.setObject(locationManager.location?.coordinate.longitude, forKey: "longitude")
        // set Image in CK
//        if let url = imageURL {
//            let imageAsset = CKAsset(fileURL: url)
//            locRecord.setObject(imageAsset, forKey: "photo")
//        }
//        else {
//            let fileURL = NSBundle.mainBundle().URLForResource("no_image", withExtension: "png")
//            let imageAsset = CKAsset(fileURL: fileURL!)
//            locRecord.setObject(imageAsset, forKey: "photo")
//        }
        //timeStamp in CK
         locRecord.setObject(NSDate(), forKey: "timestamp")

        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase		// iclou.iblur.Demo
        
        
        publicDatabase.saveRecord(locRecord, completionHandler: { (record, error) -> Void in
            if (error != nil) {
                print(error)
            }
            
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                // self.viewWait.hidden = true
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                
                if self.summaryTextField != "" {
                self.navigationController!.popViewControllerAnimated(true)
                    
                }

            })
        })
    }
    
    // Take and save a picture
    
    var cameraUI: UIImagePickerController! = UIImagePickerController()
    
    //--- Take Photo from Camera ---//
    @IBAction func takePhotoFromCamera(sender: AnyObject)
    {
        self.presentCamera()
    }
    
    func presentCamera()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        {
            print("Button capture")
            
            cameraUI = UIImagePickerController()
            cameraUI.delegate = self
            cameraUI.sourceType = UIImagePickerControllerSourceType.Camera;
            cameraUI.mediaTypes = [kUTTypeImage as String]
            cameraUI.allowsEditing = false
            
            self.presentViewController(cameraUI, animated: true, completion: nil)
        }
        else
        {
        }
    }
    
    
    @IBAction func pickPhoto(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            //access a la libairie de ton device
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func setPhoto() {
        
        if let url = imageURL {
            
            let identifier = NSUUID().UUIDString
            let photoID = CKRecordID(recordName: identifier)
            let pictureRecord = CKRecord(recordType: "Location", recordID: photoID)
            
            let imageAsset = CKAsset(fileURL: url)
            pictureRecord.setObject(imageAsset, forKey: "photo")
            
        }
        
    }
    
    func saveImageLocally() { //om een file aanmaken
        
        let imageData: NSData = UIImageJPEGRepresentation(locationImage.image!, 0.8)!
        
        let path = documentsDirectoryPath.stringByAppendingString(tempImageName)
        
        imageURL = NSURL(fileURLWithPath: path)
        
        imageData.writeToURL(imageURL!, atomically: true)
    }
    
    
//    func imagePickerControllerDidCancel(picker:UIImagePickerController)
//    {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        if(picker.sourceType == UIImagePickerControllerSourceType.Camera)
//        {
//            
//            let imageToSave1: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//            
//            UIImageWriteToSavedPhotosAlbum(imageToSave1, nil, nil, nil)
//            
//            let imageData = UIImageJPEGRepresentation(imageToSave1, 1)
//            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//            let documentDirectory = paths[0] as String
//            let myFilePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("photo")
//            
//            let asset = CKAsset(fileURL: myFilePath)
//            
//            let identifier = NSUUID().UUIDString //format cle unique
//            let locID = CKRecordID(recordName : identifier)
//            let locRecord = CKRecord(recordType: "Location", recordID: locID)
//            
//            var imageURL: NSURL?
//            
//            if let url = imageURL {
//                let imageAsset = CKAsset(fileURL: url)
//                locRecord.setObject(imageAsset, forKey: "photo")
//            }
//            else {
//                let fileURL = NSBundle.mainBundle().URLForResource("no_image", withExtension: "png")
//                
//                
//            }
//            self.savedImageAlert()
//            self.dismissViewControllerAnimated(true, completion: nil)
//            
//            
//        }
//        
//    }
    
    func savedNoteAlert() {
        
        let alert: UIAlertView = UIAlertView()
        alert.title = "Gone"
        alert.message = "Your location has been sent"
        alert.delegate = self
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    func savedImageAlert() {
        
        let alert:UIAlertView = UIAlertView()
        alert.title = "Saved!"
        alert.message = "Your picture was saved to Camera Roll"
        alert.delegate = self
        alert.addButtonWithTitle("Ok")
        alert.show()
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

extension AddLocationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        locationImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        locationImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        saveImageLocally()// pour utilser cloudkit
        
        locationImage.hidden = false

        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

