//
//  PlayGameSolutionViewController.swift
//  
//
//  Created by Jean Smits on 19/04/16.
//
//

import UIKit

class PlayGameSolutionViewController: UIViewController {

    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var gameDescriptionLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    var timer = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var clock = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "countdown", userInfo: nil, repeats: true)

fillTheLabels()
    


        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillTheLabels() {
    
        
    }
    
    func countdown() {
        timerLabel.text = String(timer)
        timer -= 1
        
        if timer <= 0 {
            timerLabel.text = "Verloren"
        
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

}
