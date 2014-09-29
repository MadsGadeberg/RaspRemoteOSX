//
//  AppDelegate.swift
//  RaspRemoteOSX
//
//  Created by Mads Gadeberg Jensen on 24/09/14.
//  Copyright (c) 2014 Mads Gadeberg Jensen. All rights reserved.
//

import Cocoa

 public class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet var statusMenu: NSMenu!
    
    var statusItem: NSStatusItem?
    var tcpService: TcpService = TcpService()
    
    var settingsWindowController = SettingsWindowController(windowNibName: "SettingsWindowController")
    
    public func applicationDidFinishLaunching(aNotification: NSNotification?) {
        let bar = NSStatusBar.systemStatusBar()
        statusItem = bar.statusItemWithLength(20)
        statusItem!.menu = statusMenu
        statusItem!.image = NSImage(byReferencingFile: NSBundle.mainBundle().pathForResource("16*16", ofType: "png"))
        statusItem!.highlightMode = true
        
        tcpService.initOutputStream()
    }
    
    public func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
    
    @IBAction func Chnl_0_ON(sender: AnyObject) {
        tcpService.SendMsg("0 1")
    }
    @IBAction func Chnl_0_OFF(sender: AnyObject) {
        tcpService.SendMsg("0 0")
    }
    @IBAction func Chnl_1_ON(sender: AnyObject) {
        tcpService.SendMsg("1 1")
    }
    @IBAction func Chnl_1_OFF(sender: AnyObject) {
        tcpService.SendMsg("1 0")
    }
    @IBAction func openSettings(sender: AnyObject) {
        // open settings for ip and port optional port
        settingsWindowController.showWindow(self)
    }
}

