//
//  StartGameViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 19/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit

class StartGameViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!

    @IBOutlet weak var catAnimation: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var catAnimationArray = ["giphy-0", "giphy-1", "giphy-2", "giphy-3", "giphy-4", "giphy-5", "giphy-6", "giphy-7", "giphy-8", "giphy-9", "giphy-10", "giphy-11", "giphy-12"]
        
        var images = [UIImage]()

        for i in 0..<catAnimationArray.count {
            images.append(UIImage(named: catAnimationArray[i])!)
        }
        
        catAnimation.animationImages = images
        catAnimation.animationDuration = 1.0
        catAnimation.startAnimating()
        


    }
    
    override func viewDidAppear(animated: Bool) {
        

        UIView.animateWithDuration(50.9, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.backgroundImage.frame.origin.x -= 350
            }, completion: { (finished: Bool) in
                print("Animation Ended!")
        });
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
