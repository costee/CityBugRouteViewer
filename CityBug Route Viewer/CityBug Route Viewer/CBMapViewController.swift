//
//  CBMapViewController.swift
//  CityBug Route Viewer
//
//  Created by Nagy Konstantin on 2015. 10. 20..
//  Copyright © 2015. Nagy Konstantin. All rights reserved.
//

import Cocoa
import MapKit

class CBMapViewController: NSViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .Hybrid
            mapView.delegate = self
        }
    }
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    var previousMapRect = MKMapRect()
    var firstDrawing = true
    var meetingPoints = [MeetingPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        progressIndicator.displayedWhenStopped = false
        progressIndicator.controlTint = .ClearControlTint
        drawAll()
        
        //GPXHelper.sharedInstance.gpxURL = NSURL(string: "http://cs193p.stanford.edu/Vacation.gpx") // for demo/debug/testing
        //GPXHelper.sharedInstance.gpxURL = NSURL(string: "https://dl.dropboxusercontent.com/u/2857701/GPX_files/2370576.gpx") // for demo/debug/testing
        
    }
    
    
    @IBAction func calculate(sender: NSButton) {
        calculateMeetingPoints()
    }
    
    @IBAction func refreshMap(sender: NSButton) {
        drawAll()
    }
    
    func convertRouteToCL(route:Route) -> [CLLocationCoordinate2D] {
        var array = [CLLocationCoordinate2D]()
        if route.routeLocations.count != 0 {
        for (var i:UInt = 0; i < route.routeLocations.count; i++) {
            array.append(CLLocationCoordinate2D(latitude: (route.routeLocations.objectAtIndex(i) as! RouteLocation).latitude, longitude: (route.routeLocations.objectAtIndex(i) as! RouteLocation).longitude))
        }
        }
        return array
    }
    
    func drawAll() {
        for var i = 0; i < RouteStore.sharedInstance.count; i++ {
            drawLine(convertRouteToCL(RouteStore.sharedInstance.get(i)))
        }
        drawMeetingPoints()
    }
    
    func zoomToPolyLine(polyline: MKPolyline, animated: Bool) {
        if firstDrawing {
            mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: NSEdgeInsetsMake(10.0, 10.0, 10.0, 10.0), animated: animated)
            previousMapRect = polyline.boundingMapRect
            firstDrawing = false
        } else {
            let newRect = MKMapRectUnion(previousMapRect, polyline.boundingMapRect)
            mapView.setVisibleMapRect(newRect, edgePadding: NSEdgeInsetsMake(10.0, 10.0, 10.0, 10.0), animated: animated)
            previousMapRect = newRect
        }
    }
    
    func drawLine(var routeLocations: [CLLocationCoordinate2D]) {
        
        if (routeLocations.count > 1) {
            let polyline = MKPolyline(coordinates: &routeLocations, count: routeLocations.count)
            
            zoomToPolyLine(polyline, animated: true)
            
            mapView.addOverlay(polyline)
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        print("I'm drawing on the map")
        
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = NSColor.purpleColor()
            polylineRenderer.lineWidth = 1
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    func drawMeetingPoints() {
        var bigMeetingPoints = [MeetingPoint]()
        for meetingPoint in meetingPoints {
            if meetingPoint.size > 10 {
                bigMeetingPoints.append(meetingPoint)
            }
        }
        var deletableMeetingPoints = [MeetingPoint]()
        for var j = 0; j < bigMeetingPoints.count; j++ {
            let bigMeetingPoint = bigMeetingPoints[j]
            var i = 0
            for ; i<bigMeetingPoints.count; i++ {
                let otherMeetingPoint = bigMeetingPoints[i]
                if bigMeetingPoint.distanceFromMP(otherMeetingPoint) < 2000 {
                    if bigMeetingPoint.size >= otherMeetingPoint.size && bigMeetingPoint != otherMeetingPoint {
                        deletableMeetingPoints.append(otherMeetingPoint)
                    }
                }
            }
        }
        for x in deletableMeetingPoints {
            if let index = bigMeetingPoints.indexOf(x) {
                bigMeetingPoints.removeAtIndex(index)
            }
        }
        for bigMeetingPoint in bigMeetingPoints {
            let annotation = MKPointAnnotation()
            annotation.coordinate = bigMeetingPoint.coordinate
            annotation.title = String(bigMeetingPoint.size)
            mapView.addAnnotation(annotation)
        }
    }
    
    func setupMeetingPoints() {
        print("setupMeetingPoints started")
        
        for (var i:UInt = 0; i < RouteStore.sharedInstance.allRouteLocations.count; i+=UInt(RouteStore.sharedInstance.allRouteLocations.count/100)) {
            let temp = MeetingPoint()
            temp.location = (RouteStore.sharedInstance.allRouteLocations.objectAtIndex(i) as! RouteLocation).getLocationInCLLocation()
            meetingPoints.append(temp)
        }
        
        
//        for var j = 0; j < RouteStore.sharedInstance.count; j++ {
//            let route = RouteStore.sharedInstance.get(j)
//            for (var i:UInt = 0; i < route.routeLocations.count; i+=50) {
//                    let temp = MeetingPoint()
//                    temp.location = (route.routeLocations.objectAtIndex(i) as! RouteLocation).getLocationInCLLocation()
//                    meetingPoints.append(temp)
//            }
//        }
        print("setupMeetingPoints created \(meetingPoints.count) pieces of MeetingPoints")
    }
    
    func calculateMeetingPoints() {
        progressIndicator.startAnimation(nil)
        if meetingPoints.isEmpty {
            setupMeetingPoints()
        }
        
        
        for meetingPoint in meetingPoints {
            for (var i:UInt = 0; i < RouteStore.sharedInstance.allRouteLocations.count; i++) {
                meetingPoint.distanceFrom(RouteStore.sharedInstance.allRouteLocations.objectAtIndex(i) as! RouteLocation)            }
        }
        
        
//        for meetingPoint in meetingPoints {
//            for var j = 0; j < RouteStore.sharedInstance.count; j++ {
//                let route = RouteStore.sharedInstance.get(j)
//                for (var i:UInt = 0; i < route.routeLocations.count; i++) {
//                    if meetingPoint.distanceFrom(route.routeLocations.objectAtIndex(i) as! RouteLocation) {
//                        i+=100
//                    }
//                    }
//                }
//            }
        progressIndicator.stopAnimation(nil)
        }
    
}
