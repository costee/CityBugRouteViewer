//
//  CBUser.swift
//  CityBug
//
//  Created by Nagy Konstantin on 2015. 08. 10..
//  Copyright (c) 2015. Nagy Konstantin. All rights reserved.
//

import Foundation
import MapKit
import Realm

class Route: RLMObject {
    dynamic var start: NSDate = NSDate()
    dynamic var title: String = ""
    dynamic var image: String = ""
    dynamic var averageSpeed: Double = 0
    dynamic var maxSpeed: Double = 0
    dynamic var distance: Double = 0
    dynamic var routeLocations = RLMArray(objectClassName: "RouteLocation")
    
    func formattedStart(isRelative: Bool) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        formatter.doesRelativeDateFormatting = isRelative
        
        return formatter.stringFromDate(self.start)
    }
    
    func addRouteLocation(routeLocation: RouteLocation) {
        routeLocations.addObject(routeLocation)
    }
    
    func addRouteLocations(newLocations: [RouteLocation]) {
        routeLocations.addObjects(newLocations)
    }
    
    func addRouteLocationFromCLLocation(location: CLLocation) {
        routeLocations.addObject(RouteLocation().setupRoute(location))
    }
    
    func calculateStats() {
        //getting speeds
        var routeLocation = RouteLocation()
        
        for var i = 0; i < Int(routeLocations.count); i++ {
            routeLocation = routeLocations.objectAtIndex(UInt(i)) as! RouteLocation
            if routeLocation.speed > maxSpeed {
                maxSpeed = routeLocation.speed
            }
            averageSpeed+=routeLocation.speed
        }
        averageSpeed /= Double(routeLocations.count)
    }
    
    override var description:  String {
        get {
        return "Route started at: \(formattedStart(true)) with the title of: \(title)"
        }
    }
}

class RouteLocation: RLMObject {
    
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    dynamic var timeStamp: NSDate = NSDate()
    dynamic var speed: Double = 0
    
    func setupRoute (location: CLLocation) -> RouteLocation {
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        timeStamp = location.timestamp
        speed = location.speed * 3.6
        return self
    }
    
    func getLocationForDrawing() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    func getLocationInCLLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}