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


class PlayGameMapViewTableViewController: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = LocationManager.sharedManager
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var destinationLabel: UILabel!
    
    var mapLocationManager: CLLocationManager!
    var myLocations: [CLLocation] = []
    
    var riddleArray: [CKRecord] = []
    let location = CLLocationManager()
    var isInitialized = false
    
    
    
       var array1 = []
    var arrayInNearby = []
    
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
        
        let image = UIImage(named: "sherlockmini")
        navigationItem.titleView = UIImageView(image: image)
        
        
        mapAnotation()
        walkingRoute()
        
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlayGameMapViewTableViewController.userLocationChanged(_:)), name: LocationManagerDidUpdateLocation, object: nil)
//    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
//    func userLocationChanged(notification: NSNotification) {
//        
//        
//        let ridrecord: CKRecord
//
//        
//        let isNearby = LocationManager.sharedManager.isNearRecord(ridrecord)
//        
//        if isNearby  {
//            
//            
//            arrayInNearby.append(isNearby)
//            
//        }
//
//        if array1 != arrayInNearby {
//            
//            
//            self.tableView.reloadData()
//            
//            array1 = arrayInNearby
//        }
//        
//        
//        // Hou bij welke records in de buurt zijn (als property(nog aan te maken)).
//        // Maak een nieuwe array aan voor alle records die in de buurt zijn en doorloop alle records.
//        // Indien de nieuwe array verschilt van de vorige array (die in de property zit) -> reloadtableview
//        // vorige array (property) = nieuwe array
//    }
    
    func mapAnotation() {
        self.mapView.delegate = self
        
        if mapLocationManager == nil {
            mapLocationManager = CLLocationManager()
            mapLocationManager.delegate = self
            mapLocationManager.desiredAccuracy = kCLLocationAccuracyBest
            mapLocationManager.requestAlwaysAuthorization()
            mapLocationManager.startUpdatingLocation()
            setAnotation()
            
            mapView.showsUserLocation = true
        }
        
    }
    
    
    
    func showAnnotationForActiveRecord() { // aan te roepen in view will appear bijvoorbeeld
        
        
        // zie onderstaande functie
        
        // verwijder de al bestaande annotation
        if let annotationForActiveRecord = annotationForActiveRecord {
            mapView.removeAnnotation(annotationForActiveRecord)
        }
        
        // voeg een nieuwe annotation toe
//        annotationForActiveRecord = ...
    }
    
    // mag weg:
    func setAnotation() {
        
        let locManager = CLLocationManager() // kan nu via manager
        locManager.requestWhenInUseAuthorization()
        var currentLocation = CLLocation!()
        currentLocation = locManager.location
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 50.881581, longitude: 4.711865)
        
        
        
        let anotation = MKPointAnnotation()
        anotation.coordinate = location
        anotation.title = "Kristof Renotte"
        anotation.subtitle = "op 20 km van uw locatie"
        
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
        
//        let isNearby = LocationManager.sharedManager.isNearRecord(ridRecord)
//        
//        if isNearby {
//            
//            
//            cell.backgroundColor = UIColor.blueColor()
//            
//            // bijvoorbeeld geef cell een andere kleur (bijvoorbeeld)
//            // stel eventueel selectionstate in
//        }
//        else {
//            // geef de standaard kleur
//            
//            cell.backgroundColor = UIColor.greenColor()
//        }
        
        
        let location = ridRecord.valueForKey("location")
        //let lat = location?.coordinate.latitude
        //let long = location?.coordinate.longitude
        cell.locationTitleLabel?.text =  ridRecord.valueForKey("nameLocation") as? String
        // Game
        cell.gameTitleLabel?.text = " " //ridRecord.valueForKey("game_description") as? String
        
        return cell
    }
    
    func walkingRoute() {
        let request = MKDirectionsRequest()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 50.876281, longitude: 4.70096), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 50.881581, longitude: 4.711865), addressDictionary: nil))
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
            let indexPAth = tableView.indexPathForSelectedRow
            let recordSelected : CKRecord = riddleArray[(indexPAth?.row)!]
            playGameViewController.ridlleRecord = recordSelected
        }
    }
    
    
    
    func fetchLocation() {//location opvragen
        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true) //
        let query = CKQuery(recordType: "Riddles", predicate: predicate)//maak een cloudKit Query
        
        publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                print(results)
                
                self.riddleArray = results!
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.tableView.hidden = false
                    self.tableView.reloadData()
                    
                })
            }
        }
    }
}




       