import SystemConfiguration
import Foundation

enum ReachabilityError: Error {
    case failedToCreateWithAddress(sockaddr_in)
    case failedToCreateWithHostname(String)
    case unableToSetCallback
    case unableToSetDispatchQueue
    case unableToGetInitialFlags
}

@available(*, unavailable, renamed: "Notification.Name.reachabilityChanged")
let ReachabilityChangedNotification = NSNotification.Name("ReachabilityChangedNotification")

extension Notification.Name {
    static let reachabilityChanged = Notification.Name("reachabilityChanged")
}

class Reachability {
    
    typealias NetworkReachable = (Reachability) -> ()
    typealias NetworkUnreachable = (Reachability) -> ()
    
    @available(*, unavailable, renamed: "Connection")
    enum NetworkStatus: CustomStringConvertible {
        case notReachable, reachableViaWiFi, reachableViaWWAN
        var description: String {
            switch self {
            case .reachableViaWWAN: return "Cellular"
            case .reachableViaWiFi: return "WiFi"
            case .notReachable: return "No Connection"
            }
        }
    }
    
    enum Connection: CustomStringConvertible {
        case none, wifi, cellular
        var description: String {
            switch self {
            case .cellular: return "Cellular"
            case .wifi: return "WiFi"
            case .none: return "No Connection"
            }
        }
    }
    
    var whenReachable: NetworkReachable?
    var whenUnreachable: NetworkUnreachable?
    
    @available(*, deprecated, renamed: "allowsCellularConnection")
    let reachableOnWWAN: Bool = true
    
    var allowsCellularConnection: Bool
    var notificationCenter: NotificationCenter = NotificationCenter.default
    
    @available(*, deprecated, renamed: "connection.description")
    var currentReachabilityString: String {
        return "\(connection)"
    }
    
    @available(*, unavailable, renamed: "connection")
    var currentReachabilityStatus: Connection {
        return connection
    }
    
    var connection: Connection {
        if flags == nil {
            try? setReachabilityFlags()
        }
        
        switch flags?.connection {
        case .none?, nil: return .none
        case .cellular?: return allowsCellularConnection ? .cellular : .none
        case .wifi?: return .wifi
        }
    }
    
    private var isRunningOnDevice: Bool = {
#if targetEnvironment(simulator)
        return false
#else
        return true
#endif
    }()
    
    private var notifierRunning = false
    private let reachabilityRef: SCNetworkReachability
    private let reachabilitySerialQueue: DispatchQueue
    private(set) var flags: SCNetworkReachabilityFlags? {
        didSet {
            guard flags != oldValue else { return }
            reachabilityChanged()
        }
    }
    
    required init(reachabilityRef: SCNetworkReachability, queueQoS: DispatchQoS = .default, targetQueue: DispatchQueue? = nil) {
        self.allowsCellularConnection = true
        self.reachabilityRef = reachabilityRef
        self.reachabilitySerialQueue = DispatchQueue(label: "uk.co.ashleymills.reachability", qos: queueQoS, target: targetQueue)
    }
    
    convenience init?(hostname: String, queueQoS: DispatchQoS = .default, targetQueue: DispatchQueue? = nil) {
        guard let ref = SCNetworkReachabilityCreateWithName(nil, hostname) else { return nil }
        self.init(reachabilityRef: ref, queueQoS: queueQoS, targetQueue: targetQueue)
    }
    
    convenience init?(queueQoS: DispatchQoS = .default, targetQueue: DispatchQueue? = nil) {
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)
        
        guard let ref = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress) else { return nil }
        
        self.init(reachabilityRef: ref, queueQoS: queueQoS, targetQueue: targetQueue)
    }
    
    deinit {
        stopNotifier()
    }
}

extension Reachability {
    
    func startNotifier() throws {
        guard !notifierRunning else { return }
        
        let callback: SCNetworkReachabilityCallBack = { (reachability, flags, info) in
            guard let info = info else { return }
            
            let reachability = Unmanaged<Reachability>.fromOpaque(info).takeUnretainedValue()
            reachability.flags = flags
        }
        
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged<Reachability>.passUnretained(self).toOpaque())
        if !SCNetworkReachabilitySetCallback(reachabilityRef, callback, &context) {
            stopNotifier()
            throw ReachabilityError.unableToSetCallback
        }
        
        if !SCNetworkReachabilitySetDispatchQueue(reachabilityRef, reachabilitySerialQueue) {
            stopNotifier()
            throw ReachabilityError.unableToSetDispatchQueue
        }
        
        try setReachabilityFlags()
        
        notifierRunning = true
    }
    
    func stopNotifier() {
        defer { notifierRunning = false }
        
        SCNetworkReachabilitySetCallback(reachabilityRef, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachabilityRef, nil)
    }
    
    @available(*, deprecated, message: "Please use `connection != .none`")
    var isReachable: Bool {
        return connection != .none
    }
    
    @available(*, deprecated, message: "Please use `connection == .cellular`")
    var isReachableViaWWAN: Bool {
        return connection == .cellular
    }
    
    @available(*, deprecated, message: "Please use `connection == .wifi`")
    var isReachableViaWiFi: Bool {
        return connection == .wifi
    }
    
    var description: String {
        guard let flags = flags else { return "unavailable flags" }
        let W = isRunningOnDevice ? (flags.isOnWWANFlagSet ? "W" : "-") : "X"
        let R = flags.isReachableFlagSet ? "R" : "-"
        let c = flags.isConnectionRequiredFlagSet ? "c" : "-"
        let t = flags.isTransientConnectionFlagSet ? "t" : "-"
        let i = flags.isInterventionRequiredFlagSet ? "i" : "-"
        let C = flags.isConnectionOnTrafficFlagSet ? "C" : "-"
        let D = flags.isConnectionOnDemandFlagSet ? "D" : "-"
        let l = flags.isLocalAddressFlagSet ? "l" : "-"
        let d = flags.isDirectFlagSet ? "d" : "-"
        
        return "\(W)\(R) \(c)\(t)\(i)\(C)\(D)\(l)\(d)"
    }
}

private extension Reachability {
    
    func setReachabilityFlags() throws {
        try reachabilitySerialQueue.sync { [unowned self] in
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags) {
                self.stopNotifier()
                throw ReachabilityError.unableToGetInitialFlags
            }
            
            self.flags = flags
        }
    }
    
    func reachabilityChanged() {
        let block = connection != .none ? whenReachable : whenUnreachable
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            block?(strongSelf)
            strongSelf.notificationCenter.post(name: .reachabilityChanged, object: strongSelf)
        }
    }
}

extension SCNetworkReachabilityFlags {
    
    typealias Connection = Reachability.Connection
    
    var connection: Connection {
        guard isReachableFlagSet else { return .none }
        
#if targetEnvironment(simulator)
        return .wifi
#else
        var connection = Connection.none
        
        if !isConnectionRequiredFlagSet {
            connection = .wifi
        }
        
        if isConnectionOnTrafficOrDemandFlagSet {
            if !isInterventionRequiredFlagSet {
                connection = .wifi
            }
        }
        
        if isOnWWANFlagSet {
            connection = .cellular
        }
        
        return connection
#endif
    }
    
    var isOnWWANFlagSet: Bool {
#if os(iOS)
        return contains(.isWWAN)
#else
        return false
#endif
    }
    var isReachableFlagSet: Bool {
        return contains(.reachable)
    }
    var isConnectionRequiredFlagSet: Bool {
        return contains(.connectionRequired)
    }
    var isInterventionRequiredFlagSet: Bool {
        return contains(.interventionRequired)
    }
    var isConnectionOnTrafficFlagSet: Bool {
        return contains(.connectionOnTraffic)
    }
    var isConnectionOnDemandFlagSet: Bool {
        return contains(.connectionOnDemand)
    }
    var isConnectionOnTrafficOrDemandFlagSet: Bool {
        return !intersection([.connectionOnTraffic, .connectionOnDemand]).isEmpty
    }
    var isTransientConnectionFlagSet: Bool {
        return contains(.transientConnection)
    }
    var isLocalAddressFlagSet: Bool {
        return contains(.isLocalAddress)
    }
    var isDirectFlagSet: Bool {
        return contains(.isDirect)
    }
    var isConnectionRequiredAndTransientFlagSet: Bool {
        return intersection([.connectionRequired, .transientConnection]) == [.connectionRequired, .transientConnection]
    }
}
