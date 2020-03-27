//
//  Reachability.swift
//  LatestArchitechtureDemo
//
//  Created by Atinder Kaur on 5/23/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import SystemConfiguration

//MARK: Internet Methods
public let ReachabilityChangedNotification = "ReachabilityChangedNotification"

func callback(_ reachability:SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer) {
    
    let reachability = Unmanaged<Reachability>.fromOpaque(info).takeUnretainedValue()
    //let reachability = Unmanaged<Reachability>.fromOpaque(OpaquePointer(info)).takeUnretainedValue()
    
    DispatchQueue.main.async {
        reachability.reachabilityChanged(flags)
    }
}


open class Reachability: NSObject {
    
    public typealias NetworkReachable = (Reachability) -> ()
    public typealias NetworkUnreachable = (Reachability) -> ()
    
    public enum NetworkStatus: CustomStringConvertible {
        
        case notReachable, reachableViaWiFi, reachableViaWWAN
        
        public var description: String {
            switch self {
            case .reachableViaWWAN:
                return "Cellular"
            case .reachableViaWiFi:
                return "WiFi"
            case .notReachable:
                return "No Connection"
            }
        }
    }
    
    // MARK: - *** Public properties ***
    
    open var whenReachable: NetworkReachable?
    open var whenUnreachable: NetworkUnreachable?
    open var reachableOnWWAN: Bool
    open var notificationCenter = NotificationCenter.default
    
    open var currentReachabilityStatus: NetworkStatus {
        if isReachable() {
            if isReachableViaWiFi() {
                return .reachableViaWiFi
            }
            if isRunningOnDevice {
                return .reachableViaWWAN
            }
        }
        return .notReachable
    }
    
    open var currentReachabilityString: String {
        return "\(currentReachabilityStatus)"
    }
    
    // MARK: - *** Initialisation methods ***
    
    required public init?(reachabilityRef: SCNetworkReachability?) {
        reachableOnWWAN = true
        self.reachabilityRef = reachabilityRef
    }
    
    public convenience init?(hostname: String) {
        
        let nodename = (hostname as NSString).utf8String
        let ref = SCNetworkReachabilityCreateWithName(nil, nodename!)
        self.init(reachabilityRef: ref)
    }
    
    open class func reachabilityForInternetConnection() -> Reachability? {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return nil
        }
        return Reachability(reachabilityRef: defaultRouteReachability)
    }
    
    open class func reachabilityForLocalWiFi() -> Reachability? {
        
        var localWifiAddress: sockaddr_in = sockaddr_in(sin_len: __uint8_t(0), sin_family: sa_family_t(0), sin_port: in_port_t(0), sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        localWifiAddress.sin_len = UInt8(MemoryLayout.size(ofValue: localWifiAddress))
        localWifiAddress.sin_family = sa_family_t(AF_INET)
        
        // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
        let address: UInt32 = 0xA9FE0000
        localWifiAddress.sin_addr.s_addr = in_addr_t(address.bigEndian)
        
        
        guard let defaultRouteReachability = withUnsafePointer(to: &localWifiAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            
            return nil
        }
        return Reachability(reachabilityRef: defaultRouteReachability)
    }
    
    // MARK: - *** Notifier methods ***
    open func startNotifier() -> Bool {
        if notifierRunning { return true }
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = Unmanaged.passUnretained(self).toOpaque()
        stopNotifier()
        return false
    }
    
    open func stopNotifier() {
        if let reachabilityRef = reachabilityRef {
            SCNetworkReachabilitySetCallback(reachabilityRef, nil, nil)
        }
        notifierRunning = false
    }
    
    // MARK: - *** Connection test methods ***
    open func isReachable() -> Bool {
        return isReachableWithTest({ (flags: SCNetworkReachabilityFlags) -> (Bool) in
            return self.isReachableWithFlags(flags)
        })
    }
    
    open func isReachableViaWWAN() -> Bool {
        if isRunningOnDevice {
            return isReachableWithTest() { flags -> Bool in
                // Check we're REACHABLE
                if self.isReachable(flags) {
                    // Now, check we're on WWAN
                    if self.isOnWWAN(flags) {
                        return true
                    }
                }
                return false
            }
        }
        return false
    }
    
    open func isReachableViaWiFi() -> Bool {
        return isReachableWithTest() { flags -> Bool in
            // Check we're reachable
            if self.isReachable(flags) {
                
                if self.isRunningOnDevice {
                    // Check we're NOT on WWAN
                    if self.isOnWWAN(flags) {
                        return false
                    }
                }
                return true
            }
            return false
        }
    }
    
    // MARK: - *** Private methods ***
    fileprivate var isRunningOnDevice: Bool = {
        #if targetEnvironment(simulator)
        return false
        #else
        return true
        #endif
    }()
    
    fileprivate var notifierRunning = false
    fileprivate var reachabilityRef: SCNetworkReachability?
    fileprivate let reachabilitySerialQueue = DispatchQueue(label: "uk.co.ashleymills.reachability", attributes: [])
    
    fileprivate func reachabilityChanged(_ flags: SCNetworkReachabilityFlags) {
        if isReachableWithFlags(flags) {
            if let block = whenReachable {
                block(self)
            }
        } else {
            if let block = whenUnreachable {
                block(self)
            }
        }
        
        notificationCenter.post(name: Notification.Name(rawValue: ReachabilityChangedNotification), object:self)
    }
    
    fileprivate func isReachableWithFlags(_ flags: SCNetworkReachabilityFlags) -> Bool {
        let reachable = isReachable(flags)
        
        if !reachable {
            return false
        }
        if isConnectionRequiredOrTransient(flags) {
            return false
        }
        
        if isRunningOnDevice {
            if isOnWWAN(flags) && !reachableOnWWAN {
                // We don't want to connect when on 3G.
                return false
            }
        }
        
        return true
    }
    
    fileprivate func isReachableWithTest(_ test: (SCNetworkReachabilityFlags) -> (Bool)) -> Bool {
        if let reachabilityRef = reachabilityRef {
            var flags = SCNetworkReachabilityFlags(rawValue: 0)
            let gotFlags = withUnsafeMutablePointer(to: &flags) {
                SCNetworkReachabilityGetFlags(reachabilityRef, UnsafeMutablePointer($0))
            }
            
            if gotFlags {
                return test(flags)
            }
        }
        return false
    }
    
    // WWAN may be available, but not active until a connection has been established.
    // WiFi may require a connection for VPN on Demand.
    fileprivate func isConnectionRequired() -> Bool {
        return connectionRequired()
    }
    
    fileprivate func connectionRequired() -> Bool {
        return isReachableWithTest({ (flags: SCNetworkReachabilityFlags) -> (Bool) in
            return self.isConnectionRequired(flags)
        })
    }
    
    // Dynamic, on demand connection?
    fileprivate func isConnectionOnDemand() -> Bool {
        return isReachableWithTest({ (flags: SCNetworkReachabilityFlags) -> (Bool) in
            return self.isConnectionRequired(flags) && self.isConnectionOnTrafficOrDemand(flags)
        })
    }
    
    // Is user intervention required?
    fileprivate func isInterventionRequired() -> Bool {
        return isReachableWithTest({ (flags: SCNetworkReachabilityFlags) -> (Bool) in
            return self.isConnectionRequired(flags) && self.isInterventionRequired(flags)
        })
    }
    
    fileprivate func isOnWWAN(_ flags: SCNetworkReachabilityFlags) -> Bool {
        #if os(iOS)
        return flags.contains(.isWWAN)
        #else
        return false
        #endif
    }
    fileprivate func isReachable(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.reachable)
    }
    fileprivate func isConnectionRequired(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.connectionRequired)
    }
    fileprivate func isInterventionRequired(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.interventionRequired)
    }
    fileprivate func isConnectionOnTraffic(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.connectionOnTraffic)
    }
    fileprivate func isConnectionOnDemand(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.connectionOnDemand)
    }
    func isConnectionOnTrafficOrDemand(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return !flags.intersection([.connectionOnTraffic, .connectionOnDemand]).isEmpty
    }
    fileprivate func isTransientConnection(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.transientConnection)
    }
    fileprivate func isLocalAddress(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.isLocalAddress)
    }
    fileprivate func isDirect(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.isDirect)
    }
    fileprivate func isConnectionRequiredOrTransient(_ flags: SCNetworkReachabilityFlags) -> Bool {
        let testcase:SCNetworkReachabilityFlags = [.connectionRequired, .transientConnection]
        return flags.intersection(testcase) == testcase
    }
    
    fileprivate var reachabilityFlags: SCNetworkReachabilityFlags {
        if let reachabilityRef = reachabilityRef {
            
            var flags = SCNetworkReachabilityFlags(rawValue: 0)
            let gotFlags = withUnsafeMutablePointer(to: &flags) {
                SCNetworkReachabilityGetFlags(reachabilityRef, UnsafeMutablePointer($0))
            }
            
            if gotFlags {
                return flags
            }
        }
        
        return []
    }
    
    override open var description: String {
        
        var W: String
        if isRunningOnDevice {
            W = isOnWWAN(reachabilityFlags) ? "W" : "-"
        } else {
            W = "X"
        }
        let R = isReachable(reachabilityFlags) ? "R" : "-"
        let c = isConnectionRequired(reachabilityFlags) ? "c" : "-"
        let t = isTransientConnection(reachabilityFlags) ? "t" : "-"
        let i = isInterventionRequired(reachabilityFlags) ? "i" : "-"
        let C = isConnectionOnTraffic(reachabilityFlags) ? "C" : "-"
        let D = isConnectionOnDemand(reachabilityFlags) ? "D" : "-"
        let l = isLocalAddress(reachabilityFlags) ? "l" : "-"
        let d = isDirect(reachabilityFlags) ? "d" : "-"
        
        return "\(W)\(R) \(c)\(t)\(i)\(C)\(D)\(l)\(d)"
    }
    
    deinit {
        stopNotifier()
        
        reachabilityRef = nil
        whenReachable = nil
        whenUnreachable = nil
    }
}
