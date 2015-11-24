//
//  GPX.swift
//  CityBug Route Viewer
//
//  Created by Nagy Konstantin on 2015. 10. 20..
//  Copyright © 2015. Nagy Konstantin. All rights reserved.
//

import Foundation
import MapKit

class GPX: NSObject, NSXMLParserDelegate
{
    
    var waypoints = [RouteLocation]()
    var tracks = [[RouteLocation]]()
    var routes = [[RouteLocation]]()
    
    typealias GPXCompletionHandler = (GPX?) -> Void
    
    class func parse(url: NSURL, completionHandler: GPXCompletionHandler) {
        GPX(url: url, completionHandler: completionHandler).parse()
    }
    

    private let url: NSURL
    private let completionHandler: GPXCompletionHandler
    
    private init(url: NSURL, completionHandler: GPXCompletionHandler) {
        self.url = url
        self.completionHandler = completionHandler
    }
    
    private func complete(success success: Bool) {
        dispatch_async(dispatch_get_main_queue()) {
            self.completionHandler(success ? self : nil)
        }
    }
    
    private func fail() { complete(success: false) }
    private func succeed() { complete(success: true) }
    
    private func parse() {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            if let data = NSData(contentsOfURL: self.url) {
                let parser = NSXMLParser(data: data)
                parser.delegate = self
                parser.shouldProcessNamespaces = false
                parser.shouldReportNamespacePrefixes = false
                parser.shouldResolveExternalEntities = false
                parser.parse()
            } else {
                self.fail()
            }
        }
    }

    func parserDidEndDocument(parser: NSXMLParser) { succeed() }
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) { fail() }
    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) { fail() }
    
    private var input = ""

    func parser(parser: NSXMLParser, foundCharacters string: String) {
        input += string
    }
    
    private var waypoint: RouteLocation?
    private var track = [RouteLocation]()

    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        switch elementName {
            case "trkseg":
                if track.isEmpty { fallthrough }
            case "trk":
                tracks.append([RouteLocation]())
                track = tracks.last!
            case "rte":
                tracks.append([RouteLocation]())
                track = routes.last!
            case "rtept", "trkpt", "wpt":
                let latitude = Double(attributeDict["lat"]!)
                let longitude = Double(attributeDict["lon"]!)
                let temp = RouteLocation()
                temp.setupRoute(CLLocation(latitude: latitude!, longitude: longitude!))
                waypoint = temp
            default: break
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
            case "wpt":
                if waypoint != nil { waypoints.append(waypoint!); waypoint = nil }
            case "trkpt", "rtept":
                if waypoint != nil { track.append(waypoint!); waypoint = nil }
            case "trk", "trkseg", "rte":
                track = [RouteLocation]()
            default: break
        }
    }
}

private extension String {
    var trimmed: String {
        return (self as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}

extension String {
    var asGpxDate: NSDate? {
        get {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z"
            return dateFormatter.dateFromString(self)
        }
    }
}
