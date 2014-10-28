//
//  TcpService.swift
//  RaspRemoteOSX
//
//  Created by Mads Gadeberg Jensen on 25/09/14.
//  Copyright (c) 2014 Mads Gadeberg Jensen. All rights reserved.
//

import Foundation
import AppKit

// TcpService i a class that is responsible for sending messages over tcp streams.
public class TcpService : NSObject, NSStreamDelegate{
    private var outputStream: NSOutputStream?
    
    var ipAddress: String = "192.168.1.18"
    var port: Int = 8888
    
    // sets up Outputstream and opens it.
    func initOutputStream(){
        self.initOutputStream(self.ipAddress, Port: self.port)
    }
    
    // updates Address and port, then sets up OutputStream and opens it.
    func initOutputStream(IP: String, Port: Int){
        updateAddress(IP, port: Port)
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, IP as NSString, UInt32(Port), nil, &writeStream)
        
        outputStream = writeStream?.takeUnretainedValue();
        
        self.outputStream!.delegate = self
        
        self.outputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.outputStream?.open()
    }
    
    func disconnect(){
        outputStream?.close()
    }
    
    // Sends a message
    func SendMsg(msg:String) -> Int{
        return outputStream!.write(msg, maxLength: countElements(msg))
    }
    // Sends a byte
    func Send(var msg:Byte) -> Int{
        return outputStream!.write(&msg , maxLength: 1)
    }
    
    // returns the status of Outputstream
    func Status() -> NSStreamStatus?{
        return outputStream?.streamStatus
    }
    
    //returns a list of the compiters IpAddresses
    private func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String.fromCString(hostname) {
                                    addresses.append(address)
                                }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return addresses
    }
    
    //updates ipAddress and port
    private func updateAddress(let ipAddress: String, let port: Int){
        self.ipAddress = ipAddress
        self.port = port
    }
    
    // Eventhandler
    func stream(aStream: NSStream!, handleEvent eventCode: NSStreamEvent){
        switch eventCode {
            
        case NSStreamEvent.None:
            println("None")
            break
        case NSStreamEvent.OpenCompleted:
            // update logo and set label to Connected
            println("Opened")
            break
        case NSStreamEvent.HasSpaceAvailable:
            println("HasSpaceAvailable")
            break
        case NSStreamEvent.HasBytesAvailable:
            println("HasBytesAvailable")
            break
        case NSStreamEvent.ErrorOccurred:
//            var theError = aStream.streamError
//            var theAlert = NSAlert()
//            theAlert.messageText = "Error reading stream!"
//            theAlert.informativeText = "Error \(theError.code): \(theError.localizedDescription)"
//            theAlert.addButtonWithTitle("OK")
//            theAlert.runModal()
//            aStream.close()
            println("Can not connect to the host!")
            break
        case NSStreamEvent.EndEncountered:
            println("EndEncountered")
            break
        default:
            println("default")
        }
    }
}