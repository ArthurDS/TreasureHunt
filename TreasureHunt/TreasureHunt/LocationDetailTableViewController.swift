//
//  LocationDetailTableViewController.swift
//  TreasureHunt
//
//  Created by Jean Smits on 11/04/16.
//  Copyright © 2016 Embur. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CloudKit

class LocationDetailTableViewController: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let locationManager = LocationManager.sharedManager
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var isInitialized = false
//    let userLocationLattitude = Double()
//    let userLocationLongitude = Double()
    
    @IBOutlet weak var mapView: MKMapView!

    
    var mapLocationManager: CLLocationManager!
    var myLocations: [CLLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
//        let request = MKDirectionsRequest()
//
//       
//        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 50.876281, longitude: 4.70096), addressDictionary: nil))
//        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 50.881581, longitude: 4.711865), addressDictionary: nil))
//        request.requestsAlternateRoutes = false
//        
//        
//        
//        let directions = MKDirections(request: request)
//        
//        directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
//            guard let unwrappedResponse = response else { return }
//            
//            for route in unwrappedResponse.routes {
//                self.mapView.addOverlay(route.polyline)
//                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
//            }
//        }
    }

    @IBAction func segmentedControlClicked(sender: AnyObject) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
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

           
        } else {
            let request = MKDirectionsRequest()
            
            
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 50.876281, longitude: 4.70096), addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 50.881581, longitude: 4.711865), addressDictionary: nil))
            request.requestsAlternateRoutes = false
            request.transportType = .Automobile
            
            
            let directions = MKDirections(request: request)
            
            directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                for route in unwrappedResponse.routes {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }

            
        

            
        }

    }

 
    
func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
    
    let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
    
    if segmentedControl.selectedSegmentIndex == 0 {
        renderer.strokeColor = UIColor.blackColor()
        renderer.lineWidth = 1.5
        renderer.alpha = 1
    } else {
        renderer.strokeColor = UIColor.redColor()
        renderer.lineWidth = 1.5
        renderer.alpha = 1
    }
    
    return renderer
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
    
    func setAnotation() {
        
        
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        var currentLocation = CLLocation!()
        currentLocation = locManager.location
        print(currentLocation)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 50.881581, longitude: 4.711865)
        
        
        
        let anotation = MKPointAnnotation()
        anotation.coordinate = location
        anotation.title = "Kristof Renotte"
        anotation.subtitle = "op 20 km van uw locatie"
        
        mapView.addAnnotation(anotation)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
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
    
 

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as! DescriptionTableViewCell
        
        // Configure the cell...
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


