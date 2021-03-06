//
//  CluesViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 25/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
import CloudKit

class CluesViewController: UIViewController {
    
    let locationManager = LocationManager.sharedManager
    
    var riddleArray: [CKRecord] = []
    var clueArray: [CKRecord] = []
    var clueArrayByID: [CKRecord] = []
    var endGameArray: [CKRecord] = []
    var textNamesArray: [String] = []
    
    var clueRecord: CKRecord!
    var gameRecord: Int!
    var rightAnswer: String!
    
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    @IBOutlet weak var answerButton1View: UIView!
    
    @IBOutlet weak var Clue1: UIImageView!
    @IBOutlet weak var Clue2: UIImageView!
    @IBOutlet weak var Clue3: UIImageView!
    @IBOutlet weak var Clue4: UIImageView!
    @IBOutlet weak var Clue5: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchClues()
        fetchRiddles()
        hideTheButtons()
        createButtons()
        hideClues()
        fetchEndgame()
        rightAnswer = "The Judge"

        navigationController?.navigationBarHidden = false
        questionLabel.hidden = true
        
        print("========================\(gameRecord)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchAllCluesForIdGame(){
        
        for record in riddleArray{
            
            if record.valueForKey("id_clue") as? Int == gameRecord {
                clueArrayByID.append(record)
                
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.locationManager.riddleArrayByIdGame.isEmpty {
            ShowTheButtons()
            createAnswers()
        }
    }
    
    func createAnswers() {
   
            let rightAnswer = "The Judge"
            let wrogAnswer1 = "The Carpenter"
            let wrogAnswer2 = "The Priest"
            let wrogAnswer3 = "MC Hammer"
            
            let answerButtonArray = [answerButton1, answerButton2, answerButton3, answerButton4]
            textNamesArray = [rightAnswer, wrogAnswer1, wrogAnswer2, wrogAnswer3]
            
            srandom(UInt32(NSDate().timeIntervalSince1970))
            
            for answerButton in answerButtonArray {
                let choice = random() % textNamesArray.count
                let endGame = textNamesArray[choice]
                
                answerButton.setTitle(endGame, forState: .Normal)
                textNamesArray.removeAtIndex(choice)
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
    
    func hideClues() {
        
        let numberOfSolvedRiddles = self.locationManager.riddlesSolvedArray.count
        
        switch numberOfSolvedRiddles {
        case 0:
            Clue1.hidden = true
            Clue2.hidden = true
            Clue3.hidden = true
            Clue4.hidden = true
            Clue5.hidden = true
        case 1:
            Clue1.hidden = false
            Clue2.hidden = true
            Clue3.hidden = true
            Clue4.hidden = true
            Clue5.hidden = true
        case 2:
            Clue1.hidden = false
            Clue2.hidden = false
            Clue3.hidden = true
            Clue4.hidden = true
            Clue5.hidden = true
        case 3:
            Clue1.hidden = false
            Clue2.hidden = false
            Clue3.hidden = false
            Clue4.hidden = true
            Clue5.hidden = true
        case 4:
            Clue1.hidden = false
            Clue2.hidden = false
            Clue3.hidden = false
            Clue4.hidden = false
            Clue5.hidden = true
        case 5:
            Clue1.hidden = false
            Clue2.hidden = false
            Clue3.hidden = false
            Clue4.hidden = false
            Clue5.hidden = false
            ShowTheButtons()
            
            //niet vergeten te verzetten naar juiste button is pressed of zoiets
            //self.locationManager.gameIsPlayed.append(gameRecord)
            
        default:
            break
        }
        
        
    }
    
    
    func hideTheButtons() {
        answerButton1.hidden = true
        answerButton1.userInteractionEnabled = false
        
        answerButton2.hidden = true
        answerButton2.userInteractionEnabled = false
        
        answerButton3.hidden = true
        answerButton3.userInteractionEnabled = false
        
        answerButton4.hidden = true
        answerButton4.userInteractionEnabled = false
        
    }
    func mistifyButtons() {
        
    }
    
    func ShowTheButtons() {
        

        answerButton1.hidden = false
        answerButton1.userInteractionEnabled = true
        
        answerButton2.hidden = false
        answerButton2.userInteractionEnabled = true
        
        answerButton3.hidden = false
        answerButton3.userInteractionEnabled = true
        
        answerButton4.hidden = false
        answerButton4.userInteractionEnabled = true
        
        questionLabel.hidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
    
    
    
    func fetchRiddles() {
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Riddles", predicate: predicate)
        
        publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                
                print(results)
                self.riddleArray = results!
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                })
                
            }
            
        }
    }
    
    func checkAnswer(myButton: UIButton) -> Bool {
        if (myButton.titleLabel?.text == rightAnswer)
        {
            return true
        }
        else {
            return false
        }
    }

    
    func AnsweredCorrectly() {
        
        let alert = UIAlertController(title: "Congratulations", message: "You succesfully solved the murder", preferredStyle: .Alert)
        let catsonImage = UIImage(named: "catson")
        let imageView = UIImageView(frame: CGRectMake(-20, -40, 100, 140))
        imageView.image = catsonImage
        alert.view.addSubview(imageView)
        alert.addAction(UIAlertAction(title: "Thank You Catson!!!", style: UIAlertActionStyle.Default, handler: { action in self.performSegueWithIdentifier("backToPickGameID", sender: self) }))
        alert.view.tintColor = UIColor(red: 0.582, green: 0.4196, blue: 0, alpha: 1.0)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func AnsweredWrong() {
        
        let alert = UIAlertController(title: "Oooooh No", message: "You twat, he got away!", preferredStyle: .Alert)
        let catsonImage = UIImage(named: "catson")
        let imageView = UIImageView(frame: CGRectMake(-20, -40, 100, 140))
        imageView.image = catsonImage
        alert.view.addSubview(imageView)
        alert.addAction(UIAlertAction(title: "Get lost Catson!!!", style: UIAlertActionStyle.Default, handler: { action in self.performSegueWithIdentifier("backToPickGameID", sender: self) }))
        alert.view.tintColor = UIColor(red: 0.582, green: 0.4196, blue: 0, alpha: 1.0)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func goToEndGame() {
        let alert = UIAlertController(title: "Endgame:", message: "             Ready for the finale Purrlock?", preferredStyle: UIAlertControllerStyle.Alert)
        let yourImage = UIImage(named: "catson")
        let imageView = UIImageView(frame: CGRectMake(-20, -40, 100, 140))
        imageView.image = yourImage
        alert.view.addSubview(imageView)
        alert.addAction(UIAlertAction(title: "To the Endgame!!!", style: UIAlertActionStyle.Default, handler: { action in self.performSegueWithIdentifier("endGameID", sender: self) }))
        alert.view.tintColor = UIColor(red: 0.582, green: 0.4196, blue: 0, alpha: 1.0)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func fetchClues() {
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Clues", predicate: predicate)
        
        publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                
                print(results)
                self.clueArray = results!
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                })
                self.searchAllCluesForIdGame()
            }
            
        }
    }
    
    func makeButtonsInactiveAfterAnswering() {
        answerButton1.userInteractionEnabled = false
        answerButton2.userInteractionEnabled = false
        answerButton3.userInteractionEnabled = false
        answerButton4.userInteractionEnabled = false
    }
    
    func Answer1CorrectMistify() {
        answerButton2.alpha = 0.5
        answerButton3.alpha = 0.5
        answerButton4.alpha = 0.5
    }
    func Answer2CorrectMistify() {
        answerButton1.alpha = 0.5
        answerButton3.alpha = 0.5
        answerButton4.alpha = 0.5
    }
    func Answer3CorrectMistify() {
        answerButton2.alpha = 0.5
        answerButton1.alpha = 0.5
        answerButton4.alpha = 0.5
    }
    func Answer4CorrectMistify() {
        answerButton2.alpha = 0.5
        answerButton3.alpha = 0.5
        answerButton1.alpha = 0.5
    }
    
    func timesUpMistify() {
        answerButton1.alpha = 0.5
        answerButton2.alpha = 0.5
        answerButton3.alpha = 0.5
        answerButton4.alpha = 0.5
    }
    
    @IBAction func answerButton1WasPressed(sender: AnyObject) {

        makeButtonsInactiveAfterAnswering()
        self.locationManager.gameIsPlayed.append(gameRecord)

        Answer1CorrectMistify()
        answerButton1.backgroundColor = UIColor.greenColor()
        
        
        if (checkAnswer(answerButton1) ) {

            makeButtonsInactiveAfterAnswering()

            
            print("this is the correctAnswer")
            
        }
        else {

            print("Wrong!!!!")
            answerButton1.backgroundColor = UIColor.redColor()
            AnsweredWrong()
            
        }
        navigationController?.navigationBarHidden = false
        
    }
    
    @IBAction func answerButton2WasPressed(sender: AnyObject) {

        makeButtonsInactiveAfterAnswering()
        self.locationManager.gameIsPlayed.append(gameRecord)
        Answer2CorrectMistify()
        answerButton2.backgroundColor = UIColor.greenColor()
        
        if (checkAnswer(answerButton2)){

            makeButtonsInactiveAfterAnswering()
            AnsweredCorrectly()
            
            print("this is the correctAnswer")
        }
        else {

            print("Wrong!!!!")
            AnsweredWrong()
            answerButton2.backgroundColor = UIColor.redColor()
            
        }
        navigationController?.navigationBarHidden = false
        
    }
    
    @IBAction func answerButton3WasPressed(sender: AnyObject) {

        makeButtonsInactiveAfterAnswering()
        self.locationManager.gameIsPlayed.append(1)
        Answer3CorrectMistify()
        answerButton3.backgroundColor = UIColor.greenColor()
        
        if (checkAnswer((answerButton3)!)){
     
            
            AnsweredCorrectly()
            
            print("this is the correctAnswer")
        }
        else {
            print("Wrong!!!!")
            
            AnsweredWrong()
            answerButton3.backgroundColor = UIColor.redColor()
            

            
        }
        navigationController?.navigationBarHidden = false
        
    }
    
    @IBAction func answerButton4WasPressed(sender: AnyObject) {

        makeButtonsInactiveAfterAnswering()
        self.locationManager.gameIsPlayed.append(gameRecord)
        Answer4CorrectMistify()
        answerButton4.backgroundColor = UIColor.greenColor()
        
        if (checkAnswer(answerButton4!)) {

            
            AnsweredCorrectly()
            
            print("this is the correctAnswer")
        }
            
        else  {

            print("Wrong!!!!")
            answerButton4.backgroundColor = UIColor.redColor()
            
            AnsweredWrong()
            
        }
        navigationController?.navigationBarHidden = false
        
    }
    
    func fetchEndgame() {//location opvragen
        
        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true) //
        let query = CKQuery(recordType: "Endgame", predicate: predicate)//maak een cloudKit Query
        
        publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                
                print(results)
                
                self.endGameArray = results!
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                })
            }
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
    

