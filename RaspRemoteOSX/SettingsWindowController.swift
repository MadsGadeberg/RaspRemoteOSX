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
    @IBOutlet weak var connectionLabel: NSTextField!
    
    @IBAction func connect(sender: AnyObject) {
//        fatalError("not implemented yet")
        // set new ip and port
        if appDelegate != nil{
            appDelegate!.tcpService.port = self.port.integerValue
            appDelegate!.tcpService.ipAddress = self.ipAddress.stringValue
            
            // Connect again
            appDelegate!.tcpService.disconnect()
            NSOperationQueue().addOperationWithBlock({ self.updateConnectionString() })
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Loads ip and port to textboxes
        appDelegate = NSApplication.sharedApplication().delegate as? AppDelegate    // returns nil
        if appDelegate != nil{
            self.port.stringValue = String((appDelegate?.tcpService.port)!)
            self.ipAddress.stringValue = appDelegate!.tcpService.ipAddress
        }
        
        //updateConnectionString()
        NSRunLoop.currentRunLoop().addTimer( NSTimer(timeInterval: 0.5, target: self, selector: "updateConnectionString", userInfo: nil, repeats: true), forMode: NSRunLoopCommonModes)
        NSOperationQueue().addOperationWithBlock({ self.updateConnectionString() })
    }
    
    // Method that updates connectionstring
    func updateConnectionString(){
        if  self.appDelegate?.tcpService.Status() == NSStreamStatus.Open{
            connectionLabel.stringValue = "Open"
        } else if self.appDelegate?.tcpService.Status() == NSStreamStatus.Opening{
            connectionLabel.stringValue = "Opening"
        } else if self.appDelegate?.tcpService.Status() == NSStreamStatus.Closed{
            connectionLabel.stringValue = "Closed"
        } else if self.appDelegate?.tcpService.Status() == NSStreamStatus.Error{
            connectionLabel.stringValue = "Error"
        }
    }
}