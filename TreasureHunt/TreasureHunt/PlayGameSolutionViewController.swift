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
    
    @IBOutlet weak var clockImage: UIImageView!
    
    
    
    var textNamesArray : [String] = []
    var ridlleRecord : CKRecord!
    var answerRecord : CKRecord!
    
    var context: CIContext!
    var currentFilter: CIFilter!
    
    let image = UIImage(named: "sherlockmini")
    
    var clock = NSTimer()
    var timer = 180
    let kAnimationKey = "rotation"
    var correctAnswer: String!
    
    
    override func viewDidLoad() {
        
        
        
        
        
        super.viewDidLoad()
        
        clock = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(PlayGameSolutionViewController.countdown), userInfo: nil, repeats: true)
        context = CIContext(options: nil)
        currentFilter = CIFilter(name: "CISepiaTone")
        navigationItem.titleView = UIImageView(image: image)
        self.navigationItem.setHidesBackButton(false, animated: false)
        correctAnswer = (ridlleRecord.valueForKey("correctAnswer") as? String)!
        
        countdown()
        fillTheLabels()
        createButtons()
        rotateClock()
        makePictureOld()
        changeTintClock()
        randomButton()
    }
    
    
    
    func rotateClock() {
        if handsImage.layer.animationForKey(kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = 300
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(M_PI * 10.0)
            handsImage.layer.addAnimation(animate, forKey: kAnimationKey)
        }
    }
    
    func stopRotatingClock() {
        handsImage.layer.removeAllAnimations()
    }
    
    func createButtons() {
        
        answerButton1.layer.cornerRadius = 20
        answerButton1.layer.borderWidth = 2
        answerButton1.layer.borderColor = UIColor.blackColor().CGColor
        //answerButton1.setTitle(ridlleRecord.valueForKey("correctAnswer")as? String, forState: .Normal)
        
        
        answerButton2.layer.cornerRadius = 20
        answerButton2.layer.borderWidth = 2
        answerButton2.layer.borderColor = UIColor.blackColor().CGColor
        // answerButton2.setTitle(ridlleRecord.valueForKey("wrongAnswer1")as? String, forState: .Normal)
        
        answerButton3.layer.cornerRadius = 20
        answerButton3.layer.borderWidth = 2
        answerButton3.layer.borderColor = UIColor.blackColor().CGColor
        //answerButton3.setTitle(ridlleRecord.valueForKey("wrongAnswer2")as? String, forState: .Normal)
        
        
        answerButton4.layer.cornerRadius = 20
        answerButton4.layer.borderWidth = 2
        answerButton4.layer.borderColor = UIColor.blackColor().CGColor
        answerButton4.setTitle(ridlleRecord.valueForKey("wrongAnswer3")as? String, forState: .Normal)            }
    
    func fillTheLabels() {
        let img = ridlleRecord.valueForKey("photo") as? CKAsset
        
        self.locationImageView.image = UIImage(contentsOfFile: img!.fileURL.path!)
        
        self.locationImageView?.contentMode = UIViewContentMode.ScaleToFill
        
        self.summaryLabel.text = ridlleRecord.valueForKey("summary") as? String
        
        
    }
    
    func countdown() {
        
        if timer > 120 {
            clockImage.image = UIImage(named: "clock")
            timer -= 1
        }
        else if timer > 60 {
            clockImage.image = UIImage(named: "clock2")
            timer -= 1
        }
        else if timer > 0 {
            timerLabel.text = String(timer)
            timer -= 1
        }
        else {
            
            clock.invalidate()
            timesupAlert()
            stopRotatingClock()
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func changeTintClock() {
        if timer > 120 {
            clockImage.image = UIImage(named: "clock")
        }
        else if timer < 120 && timer > 60 {
            clockImage.image = UIImage(named: "clock_orange")
            print("orange")
        }
        else {
            clockImage.image = UIImage(named: "clock_red")
        }
    }
    
    func timesupAlert() {
        let alert = UIAlertController(title: "Catson:", message: "                     Un-furr-tunately your time is up Sherlock...", preferredStyle: UIAlertControllerStyle.Alert)
        
        let yourImage = UIImage(named: "catson")
        var imageView = UIImageView(frame: CGRectMake(-20, -40, 100, 140))
        imageView.image = yourImage
        alert.view.addSubview(imageView)
        alert.addAction(UIAlertAction(title: "Shut up Catson!", style: UIAlertActionStyle.Default, handler: nil))
        alert.view.tintColor = UIColor(red: 0.582, green: 0.4196, blue: 0, alpha: 1.0)
        
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func AnsweredCorrectly() {
        let alert = UIAlertController(title: "Catson:", message: "                     Gee Mittens Purlock,    this is absocatly correct", preferredStyle: UIAlertControllerStyle.Alert)
        
        let yourImage = UIImage(named: "catson")
        var imageView = UIImageView(frame: CGRectMake(-20, -40, 100, 140))
        imageView.image = yourImage
        alert.view.addSubview(imageView)
        alert.addAction(UIAlertAction(title: "Shut up Catson!", style: UIAlertActionStyle.Default, handler: nil))
        alert.view.tintColor = UIColor(red: 0.582, green: 0.4196, blue: 0, alpha: 1.0)
        
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func AnsweredWrong() {
        let alert = UIAlertController(title: "Catson:", message: "               I'm sorry Purlock, you              probably just have a dog day", preferredStyle: UIAlertControllerStyle.Alert)
        
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
    
    func addIfRiddleSolved() {
        self.locationManager.riddlesSolvedArray.append(ridlleRecord.valueForKey("nameLocation") as! String)
        print(locationManager.riddlesSolvedArray)
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
    
    @IBAction func answerButton1WasPressed(sender: AnyObject) {
        makeButtonsInactiveAfterAnswering()
        stopRotatingClock()
        Answer1CorrectMistify()
        
        
        if (checkAnswer(answerButton1) ) {
            addIfRiddleSolved()
            makeButtonsInactiveAfterAnswering()
            AnsweredCorrectly()
            
            print("this is the correctAnswer")
            
        }
        else {
            print("Wrong!!!!")
            answerButton1.backgroundColor = UIColor.redColor()
            AnsweredWrong()
        }
    }
    
    @IBAction func answerButton2WasPressed(sender: AnyObject) {
        makeButtonsInactiveAfterAnswering()
        stopRotatingClock()
        Answer2CorrectMistify()
        
        
        if (checkAnswer(answerButton2)){
            addIfRiddleSolved()
            makeButtonsInactiveAfterAnswering()
            AnsweredCorrectly()
            
            print("this is the correctAnswer")
        }
        else {
            print("Wrong!!!!")
            AnsweredWrong()
            answerButton2.backgroundColor = UIColor.redColor()
            
        }
    }
    
    @IBAction func answerButton3WasPressed(sender: AnyObject) {
        makeButtonsInactiveAfterAnswering()
        stopRotatingClock()
        Answer3CorrectMistify()
        
        
        if (checkAnswer((answerButton3)!)){
            addIfRiddleSolved()
            AnsweredCorrectly()
            print("this is the correctAnswer")
        }
        else {
            print("Wrong!!!!")
            AnsweredWrong()
            answerButton3.backgroundColor = UIColor.redColor()

        }
    }
    
    @IBAction func answerButton4WasPressed(sender: AnyObject) {
        makeButtonsInactiveAfterAnswering()
        stopRotatingClock()
        Answer4CorrectMistify()
        
        
        if (checkAnswer(answerButton4!)) {
            addIfRiddleSolved()
            AnsweredCorrectly()
            print("this is the correctAnswer")
        }
            
        else  {
            print("Wrong!!!!")
            answerButton4.backgroundColor = UIColor.redColor()
            AnsweredWrong()
        }
    }
    
    
    
    
    func checkAnswer(myButton: UIButton) -> Bool {
        if (myButton.titleLabel?.text == correctAnswer)
        {
            return true
        }
        else {
            return false
        }
        //self.performSegueWithIdentifier("riddeID", sender: self)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func randomButton(){
        let textName1 = ridlleRecord.valueForKey("correctAnswer")as? String
        let textName2 = ridlleRecord.valueForKey("wrongAnswer1")as? String
        let textName3 = ridlleRecord.valueForKey("wrongAnswer2")as? String
        let textName4 = ridlleRecord.valueForKey("wrongAnswer3")as? String
        let buttonArray = [answerButton1,answerButton2,answerButton3,answerButton4]
        textNamesArray = [textName1!,textName2!,textName3!,textName4!]
        srandom(UInt32(NSDate().timeIntervalSince1970))
        
        for button in buttonArray{
            let choice = random() % textNamesArray.count
            //            print(choice)
            let textName =  textNamesArray[choice]
            
            button.setTitle(textName, forState: .Normal)
            textNamesArray.removeAtIndex(choice)
            
        }
    }
}








