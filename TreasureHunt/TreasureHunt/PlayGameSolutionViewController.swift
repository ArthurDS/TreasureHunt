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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        fillTheLabels()
    


        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillTheLabels() {
    
        
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
