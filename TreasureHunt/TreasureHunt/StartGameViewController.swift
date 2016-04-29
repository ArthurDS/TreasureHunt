//
//  StartGameViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 19/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
import AVFoundation

func delay(seconds seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}

class StartGameViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var catAnimation: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBAction func unWindToStart(segue: UIStoryboardSegue) {}
    
    

    
    var bombSoundEffect: AVAudioPlayer!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true


        var catAnimationArray = ["giphy-0", "giphy-1", "giphy-2", "giphy-3", "giphy-4", "giphy-5", "giphy-6", "giphy-7", "giphy-8", "giphy-9", "giphy-10", "giphy-11", "giphy-12"]
        
        let path = NSBundle.mainBundle().pathForResource("Sherlock Holmes.mp3", ofType:nil)!
        let url = NSURL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            bombSoundEffect = sound
            sound.play()
        } catch {
            // couldn't load file :(
        }
        
        
        
        var images = [UIImage]()
        
        for i in 0..<catAnimationArray.count {
            images.append(UIImage(named: catAnimationArray[i])!)
        }
        
        navigationController?.navigationBarHidden = true

        playButton.layer.cornerRadius = 20
        createButton.layer.cornerRadius = 20
        playButton.layer.borderWidth = 2
        playButton.layer.borderColor = UIColor.whiteColor().CGColor
        createButton.layer.borderWidth = 2
        createButton.layer.borderColor = UIColor.whiteColor().CGColor
        catAnimation.animationImages = images
        catAnimation.animationDuration = 1.0
        catAnimation.startAnimating()
        
        LocationManager.sharedManager
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = true
playButton.center.x -= view.bounds.width
        createButton.center.x -= view.bounds.width
    }
    

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(50.9, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.backgroundImage.frame.origin.x -= 320
            }, completion: { (finished: Bool) in
                self.backgroundImage.frame.origin.x += 320
        });
//        loadView()

        
//                UIView.animateWithDuration(0.5, delay: 0.3, options: [], animations: {
//                    self.playButton.center.x -= self.view.bounds.width
//                    }, completion: nil)
//                UIView.animateWithDuration(0.5, delay: 0.4, options: [], animations: {
//                    self.createButton.center.x -= self.view.bounds.width
//                    }, completion: nil)
        
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
