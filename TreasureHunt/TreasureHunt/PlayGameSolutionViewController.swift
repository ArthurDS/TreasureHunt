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

    @IBOutlet weak var answerButton1: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
 
    @IBOutlet weak var answerButton2: UIButton!
    
    @IBOutlet weak var answerButton3: UIButton!
    
    @IBOutlet weak var answerButton4: UIButton!
    
    
    var timer = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var clock = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(PlayGameSolutionViewController.countdown), userInfo: nil, repeats: true)

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
