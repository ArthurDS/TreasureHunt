//
//  StartGameViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 19/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit

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
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var catAnimationArray = ["giphy-0", "giphy-1", "giphy-2", "giphy-3", "giphy-4", "giphy-5", "giphy-6", "giphy-7", "giphy-8", "giphy-9", "giphy-10", "giphy-11", "giphy-12"]
        
        var images = [UIImage]()

        for i in 0..<catAnimationArray.count {
            images.append(UIImage(named: catAnimationArray[i])!)
        }
        
        playButton.layer.cornerRadius = 20
        createButton.layer.cornerRadius = 20
        playButton.layer.borderWidth = 2
        playButton.layer.borderColor = UIColor.whiteColor().CGColor
        createButton.layer.borderWidth = 2
        createButton.layer.borderColor = UIColor.whiteColor().CGColor
        catAnimation.animationImages = images
        catAnimation.animationDuration = 1.0
        catAnimation.startAnimating()
        


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        playButton.center.x -= view.bounds.width
        createButton.center.x -= view.bounds.width
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animateWithDuration(50.9, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.backgroundImage.frame.origin.x -= 350
            }, completion: { (finished: Bool) in
                print("Animation Ended!")
        });
        
        UIView.animateWithDuration(0.5, delay: 0.3, options: [], animations: {
            self.playButton.center.x -= self.view.bounds.width
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.4, options: [], animations: {
            self.createButton.center.x -= self.view.bounds.width
            }, completion: nil)
        }
  
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
