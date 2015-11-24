//
//  CBWindowsController.swift
//  CityBug Route Viewer
//
//  Created by Nagy Konstantin on 2015. 10. 20..
//  Copyright © 2015. Nagy Konstantin. All rights reserved.
//

import Cocoa

class CBWindowController: NSWindowController {
    
    override init(window: NSWindow!)
    {
        super.init(window: window)
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.titleVisibility = .Hidden
        self.window?.titlebarAppearsTransparent = true
        self.window?.styleMask |= NSFullSizeContentViewWindowMask

    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

}
