//
//  PlayGameSolutionViewController.swift
//
//
//  Created by Jean Smits on 19/04/16.
//
//

import UIKit
import CloudKit

class PlayGameSolutionViewController: UIViewController,CLLocationManagerDelegate {
    
    let locationManager = LocationManager.sharedManager
    
    @IBOutlet weak var locationImageView: UIImageView!
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    @IBOutlet weak var handsImage: UIImageView!
    
    
    var ridlleRecord : CKRecord!
    
    var context: CIContext!
    var currentFilter: CIFilter!
    
    let image = UIImage(named: "sherlockmini")
    
    var clock = NSTimer()
    var timer = 60
    let kAnimationKey = "rotation"

    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        clock = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(PlayGameSolutionViewController.countdown), userInfo: nil, repeats: true)
        context = CIContext(options: nil)
        currentFilter = CIFilter(name: "CISepiaTone")
        navigationItem.titleView = UIImageView(image: image)
        
        fillTheLabels()
        createButtons()
        rotateClock()
        makePictureOld()
    }
    
    
    func rotateClock() {
        if handsImage.layer.animationForKey(kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = 100
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(M_PI * 10.0)
            handsImage.layer.addAnimation(animate, forKey: kAnimationKey)
        }
    }
    
    func createButtons() {
        answerButton1.layer.cornerRadius = 20
        answerButton1.layer.borderWidth = 2
        answerButton1.layer.borderColor = UIColor.blackColor().CGColor
        
        answerButton2.layer.cornerRadius = 20
        answerButton2.layer.borderWidth = 2
        answerButton2.layer.borderColor = UIColor.blackColor().CGColor
        
        answerButton3.layer.cornerRadius = 20
        answerButton3.layer.borderWidth = 2
        answerButton3.layer.borderColor = UIColor.blackColor().CGColor
        
        answerButton4.layer.cornerRadius = 20
        answerButton4.layer.borderWidth = 2
        answerButton4.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    func fillTheLabels() {
        let img = ridlleRecord.valueForKey("photo") as? CKAsset
        self.locationImageView.image = UIImage(contentsOfFile: img!.fileURL.path!)

        self.locationImageView?.contentMode = UIViewContentMode.ScaleToFill
        
        self.summaryLabel.text = ridlleRecord.valueForKey("summary") as? String
        
    }
    
    func countdown() {
        if timer > 0 {
            timerLabel.text = String(timer)
            timer -= 1
        }
        else {
            
            clock.invalidate()
            timesupAlert()
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func timesupAlert() {
        let alert = UIAlertController(title: "Catson:", message: "                     Un-furr-tunatly your time is up Sherlock...", preferredStyle: UIAlertControllerStyle.Alert)
        
        let yourImage = UIImage(named: "catson")
        var imageView = UIImageView(frame: CGRectMake(-20, -40, 100, 140))
        imageView.image = yourImage
        alert.view.addSubview(imageView)
        alert.addAction(UIAlertAction(title: "Shut up Catson!", style: UIAlertActionStyle.Default, handler: nil))
        alert.view.tintColor = UIColor(red: 0.582, green: 0.4196, blue: 0, alpha: 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func makePictureOld() {
        
        let imgRecord = ridlleRecord.valueForKey("photo") as? CKAsset
        let img = UIImage(contentsOfFile: imgRecord!.fileURL.path!)
        let beginImage = CIImage(image: img!)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
        
    }
    
    func applyProcessing() {
    
        let cgimg = context.createCGImage(currentFilter.outputImage!, fromRect: currentFilter.outputImage!.extent)
        let processedImage = UIImage(CGImage: cgimg)
        
        locationImageView.image = processedImage
    
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
