//
//  GPXHelper.swift
//  CityBug Route Viewer
//
//  Created by Nagy Konstantin on 2015. 10. 23..
//  Copyright © 2015. Nagy Konstantin. All rights reserved.
//

import Foundation
import MapKit

/** GPXHelper Class

*/
class GPXHelper {
    
    
    var gpxURL: NSURL? {
        didSet {
            if let url = gpxURL {
                GPX.parse(url) {
                    if let gpx = $0 {
                        let route = self.handleWaypoints(gpx.waypoints)
                        RouteStore.sharedInstance.addRoute(route)
                    }
                }
            }
        }
    }
    
    func setURL(url: NSURL) {
        gpxURL = url;
    }
    
    private func handleWaypoints(waypoints: [RouteLocation]) -> Route {
        var array = [CLLocationCoordinate2D]()
        for routeLocation in waypoints {
            array.append(routeLocation.getLocationForDrawing())
        }
        let route = Route()
        route.addRouteLocations(waypoints)
        return route
    }
    
    

    static let sharedInstance = GPXHelper()

    private init(){}
}
