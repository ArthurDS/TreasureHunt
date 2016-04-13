//
//  AddLocationViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 11/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation
import MobileCoreServices


class AddLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var locationTextField: UILabel!
    @IBOutlet weak var MyLocationView: MKMapView!
    
    @IBOutlet weak var summaryTextField: UITextField!
    
    @IBOutlet weak var currentImage: UIImageView!

    
    var newItem:Location? = nil
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var locationManager: CLLocationManager!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
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
    
    
    
    
    
    @IBAction func addLocationButton(sender: AnyObject) {
        
                if newItem == nil
        {
            let context = self.context
            let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: context)
            
            let newItem = Location(entity: entity!, insertIntoManagedObjectContext: context)
            newItem.summary = summaryTextField.text!
            
            do {
                //try context.save()
                try newItem.managedObjectContext?.save()
            } catch _ {
            }
        } else {
            
            newItem!.summary = summaryTextField.text!
            
            do {
                //try context.save()
                try newItem!.managedObjectContext?.save()
            } catch _ {
            }
        }
        
        navigationController!.popViewControllerAnimated(true)
        
        
    }
    
    
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
            // error msg
        }
    }
    
    //Mark- UIImagePickerController Delegate
    
    func imagePickerControllerDidCancel(picker:UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if(picker.sourceType == UIImagePickerControllerSourceType.Camera)
        {
            // Access the uncropped image from info dictionary
            
            //            var imageToSave: UIImage = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
            var imageToSave1: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage //same but with different way
            
            UIImageWriteToSavedPhotosAlbum(imageToSave1, nil, nil, nil)
            
            self.savedImageAlert()
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }
    
    func savedImageAlert() {
        
        var alert:UIAlertView = UIAlertView()
        alert.title = "Saved!"
        alert.message = "Your picture was saved to Camera Roll"
        alert.delegate = self
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
}

/*
 // MARK: - Navigatio n
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


