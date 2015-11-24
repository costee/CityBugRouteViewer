//
//  RouteStore.swift
//  CityBug
//
//  Created by Nagy Konstantin on 2015. 08. 10..
//  Copyright (c) 2015. Nagy Konstantin. All rights reserved.
//

import Foundation
import Realm
import MapKit

class RouteStore {
    
    var array: RLMResults {
        get {
            return Route.allObjects()
        }
    }
    
    var count: Int {
        get {
            return Int(array.count)
        }
    }
    
    
    func get(index: Int) -> Route {
        return array.objectAtIndex(UInt(index)) as! Route
    }
    
    var last: Route {
        get {
            return array.lastObject() as! Route
        }
    }
    
    func addRoute(newRoute: Route) {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        
        realm.addObject(newRoute)
        
        do {
            try realm.commitWriteTransaction()
        }
        catch {
            print("Baj van új útvonal felvételekor")
        }
        
        
    }
    
    func addRoute(start: NSDate, title: String, image: String, averageSpeed: Double, minSpeed: Double, maxSpeed:Double, routeLocations: RLMArray) {
        
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        
        let newRoute = Route()
        newRoute.start = start
        newRoute.title = title
        newRoute.image = image
        newRoute.averageSpeed = averageSpeed
        newRoute.maxSpeed = maxSpeed
        newRoute.routeLocations = routeLocations
        realm.addObject(newRoute)
        
        do {
            try realm.commitWriteTransaction()
        }
        catch {
            print("Baj van az útvonal hozzáadásakor")
        }
    }
    
    
    func remove(route: Route) {
        
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        
        realm.deleteObject(route)
        
        do {
            try realm.commitWriteTransaction()
        }
        catch {
            print("Baj van törléskor")
        }
        

    }
    
    
    func removeAt(index: Int) {
        let route = get(index)
        remove(route)
    }
    
    var allRouteLocations: RLMResults {
        get {
            return RouteLocation.allObjects()
        }
    }
    
    
    // RouteStore.sharedInstance
    class var sharedInstance: RouteStore {
        struct Static {
            static let instance = RouteStore()
        }
        return Static.instance
    }
}