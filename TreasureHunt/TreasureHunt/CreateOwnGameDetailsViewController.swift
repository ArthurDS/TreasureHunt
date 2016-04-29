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
    let locationManager = LocationManager.sharedManager

      // var locationManager: CLLocationManager!
    
    @IBOutlet weak var nameLocationField: UITextField!
   
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
    
   
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageURL: NSURL?
    let tempImageName = "temp_image.jpg"
    let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] //as NSString
    
    var  idGameForRiddle : Int32!
    
    var delegate: addQuestionViewControllerDelegatee?
    
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView = UIScrollView(frame: view.bounds)
        
        context = CIContext(options: nil)
        currentFilter = CIFilter(name: "CISepiaTone")
        navigationController?.navigationBarHidden = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateOwnGameDetailsViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateOwnGameDetailsViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        scrollView.contentSize=CGSizeMake(320,1000)

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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillBeHidden:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications()
    {
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
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func CameraRollPicture(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
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
        locRecord.setObject(summaryTextField.text, forKey: "summary")
        //id
        locRecord.setObject(Int(idGameForRiddle), forKey: ("id_Riddle"))
        // set Image in CK
        if let url = imageURL {
            let imageAsset = CKAsset(fileURL: url)
            locRecord.setValue(imageAsset, forKey: "photo")//imageAsset, forKey: "photo")
            print("asset file url before: \(imageAsset.fileURL)")
        }
        //add nameLocation
        locRecord.setObject(nameLocationField.text, forKey: "nameLocation")
        //addCurrent Location
        let myLocation = locationManager.userLocation
        locRecord.setObject(myLocation, forKey: "location")
        locRecord.setObject(answer1Field.text, forKey: "correctAnswer")
        locRecord.setObject(answer1Field2.text, forKey: "wrongAnswer1")
        locRecord.setObject(answer1Field3.text, forKey: "wrongAnswer2")
        locRecord.setObject(answer1Field4.text, forKey: "wrongAnswer3")
        
        SwitchValue()
        
        
        
        
        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase		// iclou.iblur.Demo
        
        publicDatabase.saveRecord(locRecord, completionHandler: { (record, error) -> Void in
            if (error != nil) {
                print(error)
            }
            
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                self.navigationController?.setNavigationBarHidden(false, animated: true)
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
  //  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let playgameController = segue.destinationViewController as! CreateOwnGameTableViewController
//        let indexSelected =
//        let selectedGame = gameArray[(indexSelected?.row)!]
//        
//        playgameController.gameSelected = selectedGame
//    }
//
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
        let beginImage = CIImage(image: newImage!)
        
        saveImageLocally()

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
 
