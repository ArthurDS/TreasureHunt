//
//  AddLocationViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 11/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation


class AddLocationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UILabel!
    @IBOutlet weak var MyLocationView: MKMapView!
    
    @IBOutlet weak var summaryTextField: UITextField!
    
    var newItem:Location? = nil
    
      let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var locationManager = LocationManager.sharedManager
    override func viewDidLoad() {
        super.viewDidLoad()
        MyLocationView.showsUserLocation = true
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadAnnotations()
    }
    
    func loadAnnotations() {
        self.MyLocationView.removeAnnotations(self.MyLocationView.annotations)
        
            }
    
    @IBAction func addLocationButton(sender: AnyObject) {
        if newItem == nil
        {
            let context = self.context
            let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: context)
            
            let newItem = Location(entity: entity!, insertIntoManagedObjectContext: context)
            newItem.summary = summaryTextField.text!
            
            do {
                //try context.save()
                try newItem.managedObjectContext?.save()
            } catch _ {
            }
        } else {
            
            newItem!.summary = summaryTextField.text!
           
            do {
                //try context.save()
                try newItem!.managedObjectContext?.save()
            } catch _ {
            }
        }
        
        navigationController!.popViewControllerAnimated(true)
        
        
    }

    }

    /*
    // MARK: - Navigatio n

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


