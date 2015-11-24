//
//  CBSetupViewController.swift
//  CityBug Route Viewer
//
//  Created by Nagy Konstantin on 2015. 10. 21..
//  Copyright © 2015. Nagy Konstantin. All rights reserved.
//

import Cocoa
import Realm

class CBSetupViewController: NSViewController {

    @IBOutlet weak var urlField: NSTextField!
    @IBOutlet weak var assistantText: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

    @IBAction func addURL(sender: NSButton) {
        print("addURL: " + urlField.stringValue)
        GPXHelper.sharedInstance.gpxURL = NSURL(string: urlField.stringValue)
        assistantText.textColor = NSColor(calibratedRed: 0.2, green: 0.8, blue: 0.2, alpha: 1)
        assistantText.stringValue = "Added: " + urlField.stringValue
        urlField.stringValue = ""
    }
    
    @IBAction func resetDatabase(sender: NSButton) {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        
        realm.deleteAllObjects()
        do {
            try realm.commitWriteTransaction()
        }
        catch {
            print("Baj van a törléssel");
        }
    }
    
}
