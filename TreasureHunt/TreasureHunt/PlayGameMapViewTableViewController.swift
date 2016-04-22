//
//  PlayGameMapViewTableViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 19/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
import MapKit
import CloudKit
import CoreLocation
import FillableLoaders


class PlayGameMapViewTableViewController: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = LocationManager.sharedManager

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var destinationLabel: UILabel!
    
    var mapLocationManager: CLLocationManager!
    var myLocations: [CLLocation] = []
    
    var riddleArray: [CKRecord] = []
    let location = CLLocationManager()
    var isInitialized = false
    
    
    
    var recordsInRange:[CKRecord] = []
   
    
    
    var annotationForActiveRecord: MKAnnotation?
    
    var activeLocation: CKRecord? {
        
        for records in riddleArray  {
            
            print(records)
            
        }
        
        // doorloop alle records
        // geef eerste record terug die nog niet "completed" is
        
        return riddleArray.first
            
            
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocation()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let image = UIImage(named: "sherlockmini")
        navigationItem.titleView = UIImageView(image: image)
                    print("After delete ============== \(riddleArray.count)")

        mapAnotation()

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlayGameMapViewTableViewController.userLocationChanged(_:)), name: LocationManagerDidUpdateLocation, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func userLocationChanged(notification: NSNotification) {
        
        
        var currentInRange: [CKRecord] = []
        
        for record in self.riddleArray {
            
            if locationManager.isNearRecord(record)   {
            
            currentInRange.append(record)
                
            }
            
        }
        
        if  recordsInRange != currentInRange  {
            
            
            self.tableView.reloadData()
            
            recordsInRange = currentInRange
            
            
        }

    }
    
    func showActiveLocation(notification: NSNotification) {
        
    }

    func mapAnotation() {
        self.mapView.delegate = self
        
        if mapLocationManager == nil {
            mapLocationManager = CLLocationManager()
            mapLocationManager.delegate = self
            mapLocationManager.desiredAccuracy = kCLLocationAccuracyBest
            mapLocationManager.requestAlwaysAuthorization()
            mapLocationManager.startUpdatingLocation()

            
            mapView.showsUserLocation = true
        }
        
    }
    
    
    
    
    // mag weg:
    func setAnotation(latitude: Double, longitude: Double) {
        
        let locManager = CLLocationManager() // kan nu via manager
        locManager.requestWhenInUseAuthorization()
        var currentLocation = CLLocation!()
        currentLocation = locManager.location
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        
        let anotation = MKPointAnnotation()
        anotation.coordinate = location

        
        mapView.addAnnotation(anotation)
    }
    
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        let detailButton: UIButton = UIButton(type: UIButtonType.DetailDisclosure)
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
        
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView!.canShowCallout = true
            annotationView!.image = UIImage(named: "icon")
            annotationView!.rightCalloutAccessoryView = detailButton
            
            
            
        }
        else
        {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        
        renderer.strokeColor = UIColor.blackColor()
        renderer.lineWidth = 1.5
        renderer.alpha = 1
        
        return renderer
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.riddleArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("riddleID", forIndexPath: indexPath) as! RiddleTableViewCell
        
        let ridRecord : CKRecord = riddleArray[indexPath.row]
        
                let isNearby = LocationManager.sharedManager.isNearRecord(ridRecord)
        
                if isNearby {
        
        
                    cell.locationTitleLabel.textColor = UIColor.blueColor()
        
                    // bijvoorbeeld geef cell een andere kleur (bijvoorbeeld)
                    // stel eventueel selectionstate in
                }
                else {
                    // geef de standaard kleur
                    
                    cell.locationTitleLabel.textColor = UIColor.greenColor()
                }
        
        
        
        let location = ridRecord.valueForKey("location")
        
        let lat = location?.coordinate.latitude
        let long = location?.coordinate.longitude
        
        
        
        setAnotation(lat!, longitude: long!)
        walkingRoute(lat!, longitude: long!)

        cell.locationTitleLabel?.text =  ridRecord.valueForKey("nameLocation") as? String
        // Game
        cell.gameTitleLabel?.text = " " //ridRecord.valueForKey("game_description") as? String
        
        return cell
        

    }
    
    func walkingRoute(latitude: Double, longitude: Double) {
        let request = MKDirectionsRequest()
        

        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 50.876281, longitude: 4.70096), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .Walking
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isInitialized {
            // Here is called only once
            isInitialized = true
            
            let userLocation: CLLocation = locations[0]
            let latitude = userLocation.coordinate.latitude
            let longitude = userLocation.coordinate.longitude
            let latDelta: CLLocationDegrees = 0.01
            let lonDelta: CLLocationDegrees = 0.01
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            self.mapView.setRegion(region, animated: true)
            self.mapView.showsUserLocation = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "riddleID" {
            let playGameViewController = segue.destinationViewController as! PlayGameSolutionViewController
            let indexPath = tableView.indexPathForSelectedRow
            let recordSelected : CKRecord = riddleArray[(indexPath?.row)!]
            playGameViewController.ridlleRecord = recordSelected
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        riddleArray.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        print("After delete ============== \(riddleArray.count)")
    }
    
    func fetchLocation() {//location opvragen
        
        let bezier2Path = UIBezierPath()
        bezier2Path.moveToPoint(CGPoint(x: 170.47, y: 11.16))
        bezier2Path.addCurveToPoint(CGPoint(x: 178.48, y: 21.74), controlPoint1: CGPoint(x: 170.47, y: 11.16), controlPoint2: CGPoint(x: 176.24, y: 18.78))
        bezier2Path.addCurveToPoint(CGPoint(x: 187.54, y: 25.24), controlPoint1: CGPoint(x: 181.62, y: 22.24), controlPoint2: CGPoint(x: 184.7, y: 23.4))
        bezier2Path.addCurveToPoint(CGPoint(x: 193.99, y: 31.48), controlPoint1: CGPoint(x: 190.15, y: 26.94), controlPoint2: CGPoint(x: 192.31, y: 29.08))
        bezier2Path.addCurveToPoint(CGPoint(x: 204.9, y: 32.6), controlPoint1: CGPoint(x: 197.62, y: 31.85), controlPoint2: CGPoint(x: 204.9, y: 32.6))
        bezier2Path.addCurveToPoint(CGPoint(x: 198.04, y: 42.09), controlPoint1: CGPoint(x: 204.9, y: 32.6), controlPoint2: CGPoint(x: 199.96, y: 39.43))
        bezier2Path.addCurveToPoint(CGPoint(x: 194.41, y: 57.76), controlPoint1: CGPoint(x: 198.69, y: 47.38), controlPoint2: CGPoint(x: 197.55, y: 52.93))
        bezier2Path.addCurveToPoint(CGPoint(x: 190.47, y: 62.39), controlPoint1: CGPoint(x: 193.28, y: 59.51), controlPoint2: CGPoint(x: 191.94, y: 61.05))
        bezier2Path.addCurveToPoint(CGPoint(x: 193, y: 77), controlPoint1: CGPoint(x: 192.09, y: 66.77), controlPoint2: CGPoint(x: 193, y: 71.74))
        bezier2Path.addCurveToPoint(CGPoint(x: 192.95, y: 79.03), controlPoint1: CGPoint(x: 193, y: 77.68), controlPoint2: CGPoint(x: 192.98, y: 78.36))
        bezier2Path.addCurveToPoint(CGPoint(x: 193, y: 81.64), controlPoint1: CGPoint(x: 193, y: 79.73), controlPoint2: CGPoint(x: 193, y: 80.55))
        bezier2Path.addLineToPoint(CGPoint(x: 193, y: 101.36))
        bezier2Path.addCurveToPoint(CGPoint(x: 192.67, y: 105.65), controlPoint1: CGPoint(x: 193, y: 103.56), controlPoint2: CGPoint(x: 193, y: 104.66))
        bezier2Path.addLineToPoint(CGPoint(x: 192.63, y: 105.84))
        bezier2Path.addCurveToPoint(CGPoint(x: 189.84, y: 108.63), controlPoint1: CGPoint(x: 192.15, y: 107.14), controlPoint2: CGPoint(x: 191.14, y: 108.15))
        bezier2Path.addCurveToPoint(CGPoint(x: 185.36, y: 109), controlPoint1: CGPoint(x: 188.66, y: 109), controlPoint2: CGPoint(x: 187.56, y: 109))
        bezier2Path.addLineToPoint(CGPoint(x: 154.64, y: 109))
        bezier2Path.addCurveToPoint(CGPoint(x: 150.35, y: 108.67), controlPoint1: CGPoint(x: 152.44, y: 109), controlPoint2: CGPoint(x: 151.34, y: 109))
        bezier2Path.addLineToPoint(CGPoint(x: 150.16, y: 108.63))
        bezier2Path.addCurveToPoint(CGPoint(x: 149.33, y: 108.23), controlPoint1: CGPoint(x: 149.87, y: 108.52), controlPoint2: CGPoint(x: 149.59, y: 108.39))
        bezier2Path.addCurveToPoint(CGPoint(x: 141.43, y: 108.94), controlPoint1: CGPoint(x: 147.47, y: 108.4), controlPoint2: CGPoint(x: 144.92, y: 108.63))
        bezier2Path.addCurveToPoint(CGPoint(x: 124.57, y: 88.98), controlPoint1: CGPoint(x: 128.49, y: 110.11), controlPoint2: CGPoint(x: 124.57, y: 88.98))
        bezier2Path.addCurveToPoint(CGPoint(x: 136.79, y: 57.36), controlPoint1: CGPoint(x: 124.57, y: 88.98), controlPoint2: CGPoint(x: 119.67, y: 67.95))
        bezier2Path.addCurveToPoint(CGPoint(x: 140.41, y: 63.78), controlPoint1: CGPoint(x: 153.44, y: 47.07), controlPoint2: CGPoint(x: 141.1, y: 62.91))
        bezier2Path.addCurveToPoint(CGPoint(x: 130.55, y: 88.44), controlPoint1: CGPoint(x: 139.65, y: 64.2), controlPoint2: CGPoint(x: 128.89, y: 70))
        bezier2Path.addCurveToPoint(CGPoint(x: 147, y: 101.3), controlPoint1: CGPoint(x: 131.63, y: 100.48), controlPoint2: CGPoint(x: 140.56, y: 101.89))
        bezier2Path.addCurveToPoint(CGPoint(x: 147, y: 81.64), controlPoint1: CGPoint(x: 147, y: 100.16), controlPoint2: CGPoint(x: 147, y: 81.64))
        bezier2Path.addCurveToPoint(CGPoint(x: 147.04, y: 78.99), controlPoint1: CGPoint(x: 147, y: 80.52), controlPoint2: CGPoint(x: 147, y: 79.68))
        bezier2Path.addCurveToPoint(CGPoint(x: 147, y: 77), controlPoint1: CGPoint(x: 147.01, y: 78.33), controlPoint2: CGPoint(x: 147, y: 77.67))
        bezier2Path.addCurveToPoint(CGPoint(x: 150.25, y: 60.59), controlPoint1: CGPoint(x: 147, y: 71), controlPoint2: CGPoint(x: 148.19, y: 65.39))
        bezier2Path.addCurveToPoint(CGPoint(x: 153.4, y: 54.85), controlPoint1: CGPoint(x: 151.15, y: 58.51), controlPoint2: CGPoint(x: 152.2, y: 56.58))
        bezier2Path.addCurveToPoint(CGPoint(x: 151.22, y: 45.4), controlPoint1: CGPoint(x: 152.03, y: 51.88), controlPoint2: CGPoint(x: 151.29, y: 48.66))
        bezier2Path.addCurveToPoint(CGPoint(x: 155.02, y: 32.12), controlPoint1: CGPoint(x: 151.13, y: 40.85), controlPoint2: CGPoint(x: 152.35, y: 36.22))
        bezier2Path.addCurveToPoint(CGPoint(x: 165.31, y: 23.4), controlPoint1: CGPoint(x: 157.63, y: 28.12), controlPoint2: CGPoint(x: 161.24, y: 25.17))
        bezier2Path.addCurveToPoint(CGPoint(x: 170.46, y: 11.17), controlPoint1: CGPoint(x: 166.73, y: 20.04), controlPoint2: CGPoint(x: 170.35, y: 11.43))
        bezier2Path.addLineToPoint(CGPoint(x: 170.47, y: 11.16))
        
        
        bezier2Path.closePath()
        UIColor.blackColor().setFill()
        bezier2Path.fill()
        
        
        let myPath = bezier2Path.CGPath
        var loader = WavesLoader.showLoaderWithPath(myPath)
        loader.loaderColor = UIColor.blackColor()

        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true) //
        let query = CKQuery(recordType: "Riddles", predicate: predicate)//maak een cloudKit Query
        
        publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                loader.showLoader()
                
                print(results)
                
                self.riddleArray = results!
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.tableView.hidden = false
                    self.tableView.reloadData()
                    
                loader.removeLoader()
                })
            }
        }
    }
}




       