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
        if (appDelegate != nil){
            appDelegate?.tcpService.initOutputStream(self.ipAddress.stringValue, Port: self.port.integerValue)
            
            let queue = NSOperationQueue()
            queue.addOperationWithBlock({
                self.updateConnectionString()
                self.appDelegate?.updateLogo()
            })
        }
    }
    
    @IBAction func closeBtn(sender: AnyObject) {
        if (appDelegate != nil){
//            appDelegate?.tcpService.close()
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
        let queue = NSOperationQueue()
        queue.addOperationWithBlock({
            self.updateConnectionString()
        })
    }
    
    // Method that updates connectionstring
    private func updateConnectionString(){
        // wait to set label until connected
        connectionLabel?.stringValue = "Connecting..."
        while self.appDelegate?.tcpService.Status() == NSStreamStatus.Opening{
        }
        
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