//
//  PictureViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 12/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController {
    
    
//    @IBOutlet weak var PictureImageView: UIImageView!
//    var newMedia: Bool?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        
//    }
//    
//    @IBAction func cameraRoll(sender: AnyObject) {
//        
//        if UIImagePickerController.isSourceTypeAvailable(
//            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
//            let imagePicker = UIImagePickerController()
//            
//            imagePicker.delegate = self
//            imagePicker.sourceType =
//                UIImagePickerControllerSourceType.PhotoLibrary
//            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
//            imagePicker.allowsEditing = false
//            self.presentViewController(imagePicker, animated: true,
//                                       completion: nil)
//            newMedia = false
//        }
//    
//    }
//    
//    @IBAction func useCamera(sender: AnyObject) {
//        
//        if UIImagePickerController.isSourceTypeAvailable(
//            UIImagePickerControllerSourceType.Camera) {
//            
//            let imagePicker = UIImagePickerController()
//            
//            imagePicker.delegate = self
//            imagePicker.sourceType =
//                UIImagePickerControllerSourceType.Camera
//            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
//            imagePicker.allowsEditing = false
//            
//            self.presentViewController(imagePicker, animated: true,
//                                       completion: nil)
//            newMedia = true
//        }
//        
//    }
//    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//        
//        let mediaType = info[UIImagePickerControllerMediaType] as! String
//        
//        self.dismissViewControllerAnimated(true, completion: nil)
//        
//        if mediaType.isEqualToString(kUTTypeImage as! String) {
//            let image = info[UIImagePickerControllerOriginalImage]
//                as! UIImage
//            
//            imageView.image = image
//            
//            if (newMedia == true) {
//                UIImageWriteToSavedPhotosAlbum(image, self,
//                                               "image:didFinishSavingWithError:contextInfo:", nil)
//            } else if mediaType.isEqualToString(kUTTypeMovie as! String) {
//                // Code to support video here
//            }
//            
//        }
//    }
//    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        let mediaType = info[UIImagePickerControllerMediaType] as! String
//        
//        self.dismissViewControllerAnimated(true, completion: nil)
//        
////        if mediaType.isEqualToString(kUTTypeImage as! String) {
////            let image = info[UIImagePickerControllerOriginalImage]
////                as! UIImage
//        
//        if mediaType.i
//        
//            imageView.image = image
//            
//            if (newMedia == true) {
//                UIImageWriteToSavedPhotosAlbum(image, self,
//                                               "image:didFinishSavingWithError:contextInfo:", nil)
//            } else if mediaType.isEqualToString(kUTTypeMovie as! String) {
//                // Code to support video here
//            }
//            
//        }
//    }
}

/*
  MARK: - Navigation
 
  In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  Get the new view controller using segue.destinationViewController.
  Pass the selected object to the new view controller.
 }
 */


