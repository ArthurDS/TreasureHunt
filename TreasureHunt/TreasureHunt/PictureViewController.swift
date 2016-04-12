//
//  PictureViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 12/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
import MobileCoreServices

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var PictureImageView: UIImageView!
    var newMedia: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func useCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true,
                                       completion: nil)
            newMedia = true
        }
        
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


