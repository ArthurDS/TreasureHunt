 //
//  CreateOwnGameDetailsViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 19/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
import MobileCoreServices
import CloudKit
 import QuartzCore
 import FillableLoaders


class CreateOwnGameDetailsViewController: UIViewController {
    
    var locationManager: CLLocationManager!

    @IBOutlet weak var summaryTextField: UITextView!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var answer1Field: UITextField!
    @IBOutlet weak var answer1Field2: UITextField!
    @IBOutlet weak var answer1Field3: UITextField!
    
    @IBOutlet weak var answer1Field4: UITextField!
    @IBOutlet weak var AnswerSwitch1: UISwitch!
    @IBOutlet weak var AnswerSwitch2: UISwitch!
    @IBOutlet weak var AnswerSwitch3: UISwitch!
    @IBOutlet weak var AnswerSwitch4: UISwitch!
    
    var imageURL: NSURL?
    let tempImageName = "temp_image.jpg"
    let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] //as NSString
    

    var delegate: addQuestionViewControllerDelegatee?
    
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView = UIScrollView(frame: view.bounds)
        
        context = CIContext(options: nil)
        currentFilter = CIFilter(name: "CISepiaTone")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateOwnGameDetailsViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateOwnGameDetailsViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //keyBoard dissmiss
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    // Take and save a picture
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillBeHidden:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        self.view.frame.origin.y = -197
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    

    
    var cameraUI: UIImagePickerController! = UIImagePickerController()
    
    
    //--- Take Photo from Camera ---//
//    @IBAction func takePhotoFromCamera(sender: AnyObject)
//    {
//        self.presentCamera()
//    }
    
//    func presentCamera()
//    {
//        
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
//        {
//            print("Button capture")
//            
//            cameraUI = UIImagePickerController()
//            cameraUI.delegate = self
//            cameraUI.sourceType = UIImagePickerControllerSourceType.Camera;
//            cameraUI.mediaTypes = [kUTTypeImage as String]
//            cameraUI.allowsEditing = false
//            
//            self.presentViewController(cameraUI, animated: true, completion: nil)
//        }
//        else
//        {
//        }
//    }
    
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
    
    @IBAction func CameraRollPicture(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            //access a la libairie de ton device
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func CancelButtonWasPressed(sender: AnyObject) {
        
        self.delegate?.addQuestionViewControllerCancelPressedViewController(self)
        
    }
    
    @IBAction func saveButtonWasPressed(sender: AnyObject) {
        let identifier = NSUUID().UUIDString //format cle unique
        let locID = CKRecordID(recordName : identifier)
        let locRecord = CKRecord(recordType: "Riddles", recordID: locID)
       // let identifierAnswer = NSUUID().UUIDString //format cle unique
       // let answerID = CKRecordID(recordName : identifier)
       // let ansewerRecord = CKRecord(recordType: "Answer", recordID: locID)
        // set summary in CK
        locRecord.setObject(summaryTextField.text, forKey: "summary")
        
        // set Image in CK
        if let url = imageURL {
            let imageAsset = CKAsset(fileURL: url)
            locRecord.setValue(imageAsset, forKey: "photo")//imageAsset, forKey: "photo")
                print("asset file url before: \(imageAsset.fileURL)")
        }
//        else {
//            let fileURL = NSBundle.mainBundle().URLForResource("no_image", withExtension: "png")
//            let imageAsset = CKAsset(fileURL: fileURL!)
//            locRecord.setObject(imageAsset, forKey: "photo")
//        }
        //answers in CK
        locRecord.setObject(answer1Field.text, forKey: "correctAnswer")
        locRecord.setObject(answer1Field2.text, forKey: "wrongAnswer1")
        locRecord.setObject(answer1Field3.text, forKey: "wrongAnswer2")
        locRecord.setObject(answer1Field4.text, forKey: "wrongAnswer3")
        
        

//        locRecord.setValue(switchIsChanged(AnswerSwitch1), forKey: "correctAnswer")
//        locRecord.setValue(switchIsChanged(AnswerSwitch2), forKey: "wrongAnswer1")
//        locRecord.setValue(switchIsChanged(AnswerSwitch3), forKey: "wrongAnswer2")
//        locRecord.setValue(switchIsChanged(AnswerSwitch4), forKey: "wrongAnswer3")
        
        SwitchValue()

            
        
//        let url = imageURL
//        let imageAsset = CKAsset(fileURL: url!)
//        locRecord.setObject(imageAsset, forKey: "photo")

        
        
        
        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase		// iclou.iblur.Demo
        
        publicDatabase.saveRecord(locRecord, completionHandler: { (record, error) -> Void in
            if (error != nil) {
                print(error)
            }
            
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                // self.viewWait.hidden = true
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                
//                if self.summaryTextField != "" {
//                    self.navigationController!.popViewControllerAnimated(true)
//                    
//                }
                
            })
        })
        
        
        
        self.delegate?.addQuestionViewControllerSavePressed(self)
        
    }
    

    
    func saveImageLocally() { //om een file aanmaken
        
        let imageData: NSData = UIImageJPEGRepresentation(locationImage.image!, 0.8)!
        
        let path = documentsDirectoryPath.stringByAppendingString("/" + tempImageName)
        
        imageURL = NSURL(fileURLWithPath: path)
        
        imageData.writeToURL(imageURL!, atomically: true)
        
        
    }
    
    
    func switchIsChanged(mySwitch: UISwitch) -> Bool {
        if mySwitch.on {
            return true
        } else {
           return false
        }
    }
    func SwitchValue(){
        let identifier = NSUUID().UUIDString //format cle unique
        let locID = CKRecordID(recordName : identifier)
        let locRecord = CKRecord(recordType: "Riddles", recordID: locID)
        
        if (switchIsChanged(AnswerSwitch1)) {
            locRecord.setValue(switchIsChanged(AnswerSwitch1), forKey: "correctAnswer")
            locRecord.setValue(switchIsChanged(AnswerSwitch2), forKey: "wrongAnswer1")
            locRecord.setValue(switchIsChanged(AnswerSwitch3), forKey: "wrongAnswer2")
            locRecord.setValue(switchIsChanged(AnswerSwitch4), forKey: "wrongAnswer3")
        }
            
        else if (switchIsChanged(AnswerSwitch2)) {
            
            
            locRecord.setValue(switchIsChanged(AnswerSwitch1), forKey: "wrongAnswer1")
            locRecord.setValue(switchIsChanged(AnswerSwitch2), forKey: "correctAnswer")
            locRecord.setValue(switchIsChanged(AnswerSwitch3), forKey: "wrongAnswer2")
            locRecord.setValue(switchIsChanged(AnswerSwitch4), forKey: "wrongAnswer3")
            
        }
        else if (switchIsChanged(AnswerSwitch3)) {
            
            
            locRecord.setValue(switchIsChanged(AnswerSwitch1), forKey: "wrongAnswer1")
            locRecord.setValue(switchIsChanged(AnswerSwitch2), forKey: "wrongAnswer2")
            locRecord.setValue(switchIsChanged(AnswerSwitch3), forKey: "correctAnswer")
            locRecord.setValue(switchIsChanged(AnswerSwitch4), forKey: "wrongAnswer3")
            
        }
        else {
            locRecord.setValue(switchIsChanged(AnswerSwitch1), forKey: "wrongAnswer1")
            locRecord.setValue(switchIsChanged(AnswerSwitch2), forKey: "wrongAnswer2")
            locRecord.setValue(switchIsChanged(AnswerSwitch3), forKey: "wrongAnswer3")
            locRecord.setValue(switchIsChanged(AnswerSwitch4), forKey: "correctAnswer")
            
        }
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
        
        let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imageContentMode = UIViewContentMode.ScaleAspectFit
        saveImageLocally()

        let beginImage = CIImage(image: newImage!)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        locationImage.hidden = false
        dismissViewControllerAnimated(true, completion: nil)
        
       applyProcessing()
    }
    
    func applyProcessing() {
        
        let cgimg = context.createCGImage(currentFilter.outputImage!, fromRect: currentFilter.outputImage!.extent)
        let processedImage = UIImage(CGImage: cgimg)
        
        locationImage.image = processedImage
    }
}
 
protocol addQuestionViewControllerDelegatee {
    
    func addQuestionViewControllerSavePressed(viewController: CreateOwnGameDetailsViewController)
    
    func addQuestionViewControllerCancelPressedViewController(viewController: CreateOwnGameDetailsViewController)
}

