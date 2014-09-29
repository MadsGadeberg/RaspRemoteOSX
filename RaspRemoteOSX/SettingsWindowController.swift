//
//  SettingsWindowController.swift
//  RaspRemoteOSX
//
//  Created by Mads Gadeberg Jensen on 26/09/14.
//  Copyright (c) 2014 Mads Gadeberg Jensen. All rights reserved.
//

import Cocoa

class SettingsWindowController: NSWindowController {

    var appDelegate: AppDelegate?
    @IBOutlet weak var ipAddress: NSTextField!
    @IBOutlet weak var port: NSTextField!
    
    @IBAction func connect(sender: AnyObject) {
        // update ip and port to tcpServide
        appDelegate?.tcpService.ipAddress = self.ipAddress.stringValue
        appDelegate?.tcpService.port = self.ipAddress.integerValue
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        appDelegate = NSApplication.sharedApplication().delegate as AppDelegate    // returns nil
        
        if appDelegate != nil{
            self.port.stringValue = toString(appDelegate?.tcpService.port)
            self.ipAddress.stringValue = appDelegate?.tcpService.ipAddress
        }
    }
}
