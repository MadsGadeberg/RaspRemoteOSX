//
//  TcpService.swift
//  RaspRemoteOSX
//
//  Created by Mads Gadeberg Jensen on 25/09/14.
//  Copyright (c) 2014 Mads Gadeberg Jensen. All rights reserved.
//

import Foundation

public class TcpService : NSObject, NSStreamDelegate{
    var inputStream: NSInputStream?
    var outputStream: NSOutputStream?
    
    var ipAddress: String = "192.168.1.18"
    var port: Int = 8888
    
    func initOutputStream(){
        self.initOutputStream(self.ipAddress, Port: self.port)
    }
    
    // sets up the streams and opens them.
    func initOutputStream(IP: String, Port: Int){
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, IP as NSString, UInt32(Port), nil, &writeStream)
        
        outputStream = writeStream?.takeUnretainedValue();
        
        self.outputStream!.delegate = self
        
        self.outputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.outputStream?.open()
    }
    
    public func SendMsg(msg:String) -> Int{
        return outputStream!.write(msg, maxLength: countElements(msg))
    }
    
    // sets up the streams and opens them.
    func initInputStream(Port: Int){
        var readStream: Unmanaged<CFReadStream>?
        
        let IPAdresses: [String] = getIFAddresses()
        let address = IPAdresses.count == 0 ? "localhost" : IPAdresses[0]
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, address as NSString, UInt32(Port), &readStream, nil)
        
        inputStream = readStream?.takeUnretainedValue();
        
        self.inputStream!.delegate = self
        
        self.inputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.inputStream?.open()
    }
    
    func getIFAddresses() -> [String] {
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
    
    // Eventhandler
    func stream(aStream: NSStream!, handleEvent eventCode: NSStreamEvent){
        switch eventCode {
            
        case NSStreamEvent.None:
            println("None")
            break
        case NSStreamEvent.OpenCompleted:
            println("Opened")
            break
        case NSStreamEvent.HasSpaceAvailable:
            println("HasSpaceAvailable")
            break
        case NSStreamEvent.HasBytesAvailable:
            println("HasBytesAvailable")
            break
        case NSStreamEvent.ErrorOccurred:
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
