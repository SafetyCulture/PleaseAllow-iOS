//
//  PleaseAllow.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import Foundation
import UserNotifications

/// An iOS permissions framework with built-in contextual soft ask
 
/// ```
/// Please.allow(.location(.sitePicker)) { result in
///    switch result {
///    case .allowed:
///        print("Authorized")
///    case .softDenial:
///        print("Denied Soft")
///    case .hardDenial:
///        print("Denied Hard")
///    case .restricted:
///        print("Restricted")
///    case .unavailable:
///        print("Unavailable")
///     }
 /// }
 /// ```

open class Please: NSObject {
    
    /// Requet a permission
    /// - parameter type: The type of permission you require
    /// - parameter eventListener: optional - An event tracker that can be used for analytics
    /// - parameter handler: optional - Handler for the permission request result
    
    public static func allow(_ type: PermissionRequestType, eventListener: PleaseAllowEventListener? = nil, handler: Please.Reply?) {
        var manager = type.manager
        manager.eventListener = eventListener
        manager.request(handler: handler)
    }
    
    /// Check permission status for a permission manager
    /// - parameter managerType: Permission manager for which you want to check the permission
    
    public static func status(for managerType: PermissionManagerType) -> PermissionStatus {
        let manager: PermissionManager
        switch managerType {
        case .camera:
            manager = CameraManager()
        case .photoLibrary:
            manager = PhotoLibraryManager()
        case .contacts:
            manager = ContactsManager()
        case .notifications:
            manager = NotificationsManager()
        case .location(let type):
            switch type {
            case .whenInUse:
                let location = LocationManager()
                location.locationType = .whenInUse
                manager = location
            case .always:
                let location = LocationManager()
                location.locationType = .always
                manager = location
            }
        }
        
        return manager.status
    }
}

/// Context Provider for permission managers
/// Extend this to add contexts with different messaging
/// for different parts of the app that require the same permission

public protocol PermissionContext {
    var softAsk: SoftAsk? { get }
    var deniedAlert: DeniedAlert? { get }
}

extension Please {
    /// Context Provider for Camera permission
    
    public struct Camera: PermissionContext {
        public let softAsk: SoftAsk?
        public let deniedAlert: DeniedAlert?
        
        public init (softAsk: SoftAsk?, deniedAlert: DeniedAlert?) {
            self.softAsk = softAsk
            self.deniedAlert = deniedAlert
        }
        
        public static let `default` = Camera(softAsk: .init(title: "Allow Camera Access"), deniedAlert: nil)
    }
    
    /// Context Provider for Photo Library permission
    
    public struct PhotoLibrary: PermissionContext {
        public let softAsk: SoftAsk?
        public let deniedAlert: DeniedAlert?
        
        public init (softAsk: SoftAsk?, deniedAlert: DeniedAlert?) {
            self.softAsk = softAsk
            self.deniedAlert = deniedAlert
        }

        public static let `default` = PhotoLibrary(softAsk: .init(title: "Allow Photo Library Access"), deniedAlert: nil)
    }
    
    /// Context Provider for Contacts permission
    
    public struct Contacts: PermissionContext {
        public let softAsk: SoftAsk?
        public let deniedAlert: DeniedAlert?
        
        public init (softAsk: SoftAsk?, deniedAlert: DeniedAlert?) {
            self.softAsk = softAsk
            self.deniedAlert = deniedAlert
        }

        public static let `default` = Contacts(softAsk: .init(title: "Allow Contacts Access"), deniedAlert: nil)
    }
    
    /// Context Provider for Location permission
    
    public struct Location: PermissionContext {
        public let requestType: LocationRequestType
        public let softAsk: SoftAsk?
        public let deniedAlert: DeniedAlert?
        
        public init (requestType: LocationRequestType, softAsk: SoftAsk?, deniedAlert: DeniedAlert?) {
            self.requestType = requestType
            self.softAsk = softAsk
            self.deniedAlert = deniedAlert
        }

        public static let `default` = Location(requestType: .whenInUse, softAsk: .init(title: "Allow Location Access"), deniedAlert: nil)
    }
    
    /// Context Provider for Notifications permission
    
    public struct Notifications: PermissionContext {
        public let options: UNAuthorizationOptions
        public let softAsk: SoftAsk?
        public let deniedAlert: DeniedAlert?
        
        public init (options: UNAuthorizationOptions, softAsk: SoftAsk?, deniedAlert: DeniedAlert?) {
            self.options = options
            self.softAsk = softAsk
            self.deniedAlert = deniedAlert
        }

        public static let `default` = Notifications(options: [.alert, .sound], softAsk: .init(title: "Allow Push Notifications"), deniedAlert: nil)
    }
}
