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
    var riddleArray: [CKRecord] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var destinationLabel: UILabel!
    
    
    var mapLocationManager: CLLocationManager!
    var myLocations: [CLLocation] = []
    
    let location = CLLocationManager()
    
    var isInitialized = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocation()
//        self.locationManager.fetchAllLocations { (records, error) in
//            <#code#>
//        }
        //fetchAllLocations()
        let image = UIImage(named: "sherlockmini")
        navigationItem.titleView = UIImageView(image: image)
        
        
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
        
        walkingRoute()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    func setAnotation() {
        
        
        let locManager = CLLocationManager()
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        
        let latestLocation: AnyObject = locations[locations.count - 1]
        
        let getLat: CLLocationDegrees = latestLocation.coordinate.latitude
        let getLon: CLLocationDegrees = latestLocation.coordinate.longitude
        
        let getMovedMapCenter: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
        
        let myBuddysLocation = CLLocation(latitude: 50.881581, longitude: 4.711865)
        let distances = getMovedMapCenter.distanceFromLocation(myBuddysLocation) / 1000
        
        
        let martelarenpleinlocation = CLLocation(latitude: 50.88162, longitude: 4.715218)
        let distanceMartelarenplein = getMovedMapCenter.distanceFromLocation(martelarenpleinlocation) / 1000
        
        
        let fonduehuisjelocation = CLLocation(latitude: 50.881282, longitude: 4.705740)
        let distanceFonduehuisje = getMovedMapCenter.distanceFromLocation(fonduehuisjelocation) / 1000
        
        if (Double(distances) < 5) {
            
            destinationLabel.text =   "Eindbestemming bereikt!" }  //  staat nu in textfield;  zou in tableview moeten
            
        else if(Double(distanceMartelarenplein)  < 5)  {
            
            destinationLabel.text =   "Eindbestemming bereikt!"}
            
        else if(Double(distanceFonduehuisje)  < 5)  {
            
            destinationLabel.text =   "Eindbestemming bereikt!"}
            
        else {
            
            destinationLabel.text =  String(format: "De afstand tot de eindbestemming bedraagt %.01fkm", distances)
        }
        
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
        let  location = ridRecord.valueForKey("location")
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
                // self.locArray.append(results)
                
                
                
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                    
                    
                    self.tableView.hidden = false
                    
                    
                    self.tableView.reloadData()
                    
                })
                
            }
            
            
        }
    }
}




       