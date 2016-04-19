//
//  CreateOwnGameDetailsViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 19/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
import MobileCoreServices

class CreateOwnGameDetailsViewController: UIViewController {
    
    @IBOutlet weak var locationImage: UIImageView!
    
    @IBOutlet weak var AnswerSwitch1: UISwitch!
    @IBOutlet weak var AnswerSwitch2: UISwitch!
    @IBOutlet weak var AnswerSwitch3: UISwitch!
    @IBOutlet weak var AnswerSwitch4: UISwitch!
    
    
    var imageURL: NSURL?
    var delegate: addQuestionViewControllerDelegatee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allSwitchesOff()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func allSwitchesOff() {
        AnswerSwitch1.setOn(true, animated: true)
        AnswerSwitch2.setOn(false, animated: true)
        AnswerSwitch3.setOn(false, animated: true)
        AnswerSwitch4.setOn(false, animated: true)
    }
    
    
    
    @IBAction func AnswerSwitch1ValueChanged(sender: AnyObject) {
        if AnswerSwitch1.on {
            AnswerSwitch2.setOn(false, animated: true)
            AnswerSwitch3.setOn(false, animated: true)
            AnswerSwitch4.setOn(false, animated: true)
        }
        else {
            AnswerSwitch2.setOn(true, animated: true)
        }
    }
    
    @IBAction func AnswerSwitch2ValueChanged(sender: AnyObject) {
        if AnswerSwitch2.on {
            AnswerSwitch1.setOn(false, animated: true)
            AnswerSwitch3.setOn(false, animated: true)
            AnswerSwitch4.setOn(false, animated: true)
        }
        else {
          AnswerSwitch1.setOn(true, animated: true)
        }
    }
    @IBAction func AnswerSwitch3ValueChanged(sender: AnyObject) {
        if AnswerSwitch3.on {
            AnswerSwitch2.setOn(false, animated: true)
            AnswerSwitch1.setOn(false, animated: true)
            AnswerSwitch4.setOn(false, animated: true)
        }
        else {
            AnswerSwitch1.setOn(true, animated: true)
        }
    }
    @IBAction func AnswerSwitch4ValueChanged(sender: AnyObject) {
        if AnswerSwitch4.on {
            AnswerSwitch2.setOn(false, animated: true)
            AnswerSwitch3.setOn(false, animated: true)
            AnswerSwitch1.setOn(false, animated: true)
        }
        else {
            AnswerSwitch1.setOn(true, animated: true)
        }
    }
    
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
    
    @IBAction func CancelButtonWasPressed(sender: AnyObject) {
        
        self.delegate?.addQuestionViewControllerCancelPressedViewController(self)
    }
    @IBAction func saveButtonWasPressed(sender: AnyObject) {
        
        self.delegate?.addQuestionViewControllerSavePressed(self)
        
    }
    
    
    
    //    func setPhoto() {
    //
    //        if let url = imageURL {
    //
    //            let identifier = NSUUID().UUIDString
    //            let photoID = CKRecordID(recordName: identifier)
    //            let pictureRecord = CKRecord(recordType: "Location", recordID: photoID)
    //
    //            let imageAsset = CKAsset(fileURL: url)
    //            pictureRecord.setObject(imageAsset, forKey: "photo")
    //
    //        }
    //
    //    }
    
    //    func saveImageLocally() { //om een file aanmaken
    //
    //        let imageData: NSData = UIImageJPEGRepresentation(locationImage.image!, 0.8)!
    //
    //        let path = documentsDirectoryPath.stringByAppendingString(tempImageName)
    //
    //        imageURL = NSURL(fileURLWithPath: path)
    //
    //        imageData.writeToURL(imageURL!, atomically: true)
    //
    //
    //    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension CreateOwnGameDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        locationImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        locationImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        //        saveImageLocally()// pour utilser cloudkit
        
        locationImage.hidden = false
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

protocol addQuestionViewControllerDelegatee {
    
    func addQuestionViewControllerSavePressed(viewController: CreateOwnGameDetailsViewController)
    
    func addQuestionViewControllerCancelPressedViewController(viewController: CreateOwnGameDetailsViewController)
}

