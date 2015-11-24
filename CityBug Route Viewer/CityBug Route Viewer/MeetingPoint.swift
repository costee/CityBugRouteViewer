//
//  MeetingPoint.swift
//  CityBug Route Viewer
//
//  Created by Nagy Konstantin on 2015. 10. 24..
//  Copyright © 2015. Nagy Konstantin. All rights reserved.
//

import Foundation
import MapKit

class MeetingPoint: Equatable {
    var location = CLLocation()
    var coordinate: CLLocationCoordinate2D {
        get {
            return self.location.coordinate
        }
    }
    var size = 0
    
    func distanceFrom(routeLocation:RouteLocation) -> Bool {
        let route = CLLocation(latitude: routeLocation.getLocationForDrawing().latitude, longitude: routeLocation.getLocationForDrawing().longitude)
        if route.distanceFromLocation(location) < 10 {
            size++
            return true
        }
        return false
    }
    
    func distanceFromMP(other:MeetingPoint) -> Int {
        return Int(location.distanceFromLocation(other.location))
    }
    
}

 func ==(lhs:MeetingPoint,rhs:MeetingPoint) -> Bool {
    if lhs.location == rhs.location && lhs.size == rhs.size {
        return true
    }
    return false
}

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs:CLLocationCoordinate2D) -> Bool {
    if lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude {
        return true
    }
    return false
}