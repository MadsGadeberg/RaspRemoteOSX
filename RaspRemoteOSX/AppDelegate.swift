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
    var settingsWindowController = SettingsWindowController(windowNibName: "SettingsWindowController:")
    
    public func applicationDidFinishLaunching(aNotification: NSNotification?) {
        let bar = NSStatusBar.systemStatusBar()
        statusItem = bar.statusItemWithLength(20)
        statusItem!.menu = statusMenu
        statusItem!.highlightMode = true
        
        NSWorkspace.sharedWorkspace().notificationCenter.addObserver(self, selector: "recieveSleepNotification:", name: NSWorkspaceWillSleepNotification, object: nil)
        NSWorkspace.sharedWorkspace().notificationCenter.addObserver(self, selector: "recievePowerOffNotification:", name: NSWorkspaceWillPowerOffNotification, object: nil)
        NSWorkspace.sharedWorkspace().notificationCenter.addObserver(self, selector: "recieveWakeNotification:", name: NSWorkspaceDidWakeNotification, object: nil)
        
        NSRunLoop.currentRunLoop().addTimer( NSTimer(timeInterval: 0.5, target: self, selector: "connect", userInfo: nil, repeats: true), forMode: NSRunLoopCommonModes)
            
    }
    
    func connect(){
        if self.tcpService.Status() != NSStreamStatus.Open && self.tcpService.Status() != NSStreamStatus.Opening{
            tcpService.initOutputStream()
            self.updateLogo()
        }
    }
    
    public func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
    
    @IBAction func Chnl_0_ON(sender: AnyObject) {
        //tcpService.Send(0x01)           //0000 0001
        tcpService.SendMsg("0 1")       //0000 0001
    }
    @IBAction func Chnl_0_OFF(sender: AnyObject) {
        //tcpService.Send(0x00)           //0000 0001
        tcpService.SendMsg("0 0")       //0000 0000
    }
    @IBAction func Chnl_1_ON(sender: AnyObject) {
        //tcpService.Send(0x03)           //0000 0001
        tcpService.SendMsg("1 1")       //0000 0011
    }
    @IBAction func Chnl_1_OFF(sender: AnyObject) {
        //tcpService.Send(0x02)           //0000 0001
        tcpService.SendMsg("1 0")       //0000 0010
    }
    
    // Method that opens settingsWindow
    @IBAction func openSettings(sender: AnyObject) {
        // open settings for ip and port optional port
        settingsWindowController.showWindow(self)
    }
    
    public func updateLogo(){
        statusItem!.image = NSImage(byReferencingFile: NSBundle.mainBundle().pathForResource("RaspRemoteGray", ofType: "png")!)
        while (tcpService.Status() == NSStreamStatus.Opening){}
        
        if (tcpService.Status() == NSStreamStatus.Open){
            statusItem!.image = NSImage(byReferencingFile: NSBundle.mainBundle().pathForResource("RaspRemoteOnline", ofType: "png")!)
        } else {
            statusItem!.image = NSImage(byReferencingFile: NSBundle.mainBundle().pathForResource("RaspRemoteOffline", ofType: "png")!)
        }
    }
    
    func recieveSleepNotification(sender: AnyObject){
        tcpService.SendMsg("1 1")
    }
    func recievePowerOffNotification(sender: AnyObject){
        tcpService.SendMsg("1 1")
    }
    func recieveWakeNotification(sender: AnyObject){
        tcpService.SendMsg("1 0")
    }
}

