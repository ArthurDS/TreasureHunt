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

    @IBOutlet weak var locationImageView: UIImageView!

    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var answerButton1: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var answerButton2: UIButton!
    
    @IBOutlet weak var answerButton3: UIButton!
    
    @IBOutlet weak var answerButton4: UIButton!
    
    let locationManager = LocationManager.sharedManager
    var ridlleRecord : CKRecord!
    
    var clock = NSTimer()
    var timer = 60

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clock = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(PlayGameSolutionViewController.countdown), userInfo: nil, repeats: true)
        

fillTheLabels()
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
        
        fillTheLabels()
        
        let image = UIImage(named: "sherlockmini")
        navigationItem.titleView = UIImageView(image: image)
        
        // Do any additional setup after loading the view.
        
        let kAnimationKey = "rotation"
        
        if handsImage.layer.animationForKey(kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = 100
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(M_PI * 10.0)
            handsImage.layer.addAnimation(animate, forKey: kAnimationKey)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillTheLabels() {
        let img = ridlleRecord.valueForKey("photo") as? CKAsset
        self.locationImageView.image = UIImage(contentsOfFile: img!.fileURL.path!)
       self.locationImageView?.contentMode = UIViewContentMode.ScaleAspectFit
       
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
        let alert: UIAlertView = UIAlertView()
        alert.title = "Watson:"
        alert.message = "Unfortunately, the time is up sir"
        alert.delegate = self
        alert.addButtonWithTitle("Shut up Watson")
        alert.show()
        
    }


