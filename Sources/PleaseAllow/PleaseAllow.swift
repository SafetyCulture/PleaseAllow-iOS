//
//  PleaseAllow.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import Foundation


/**
 An iOS permissions framework with built-in soft ask.
 
 ### Usage: ###
 
 ```
 PleaseAllow.location.always { result, eror in
    switch result {
    case .allowed:
        print("Authorized")
    case .softDenial:
        print("Denied Soft")
    case .hardDenial:
        print("Denied Hard")
    case .restricted:
        print("Restricted")
    case .unavailable:
        print("Unavailable")
     }
 }
 ```
  
 */

public enum PermissionRequestType {
    case camera(Please.Camera)
    case contacts(Please.Contacts)
    case photoLibrary(Please.PhotoLibrary)
    case location(Please.Location)
    case notifications(Please.Notifications)
}

extension PermissionRequestType {
    var context: PermissionContext {
        switch self {
        case .camera(let context):
            return context
        case .contacts(let context):
            return context
        case .photoLibrary(let context):
            return context
        case .location(let context):
            return context
        case .notifications(let context):
            return context
        }
    }
    
    var manager: PermissionManager {
        var activeManager: PermissionManager
        switch self {
        case .camera:
            activeManager = CameraManager()
        case .photoLibrary:
            activeManager = PhotoLibraryManager()
        case .contacts:
            activeManager = ContactsManager()
        case .location(let locationContext):
            let locationManager = LocationManager()
            locationManager.locationType = locationContext.requestType
            activeManager = locationManager
        case .notifications:
            activeManager = NotificationsManager()
        }
        
        activeManager.softAskView = context.softAskView
        activeManager.deniedAlert = context.deniedAlert
        return activeManager
    }
}

public protocol PermissionContext {
    var softAskView: SoftAskView? { get }
    var deniedAlert: DeniedAlert? { get }
}

open class Please: NSObject {
    /// Shared Instance to be used for all permission requests.
    
    public static func shareStatus(for managerType: PermissionManagerType) -> PermissionStatus {
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
        case .locationWhenInUse:
            let location = LocationManager()
            location.locationType = .whenInUse
            manager = location
        case .locationAlways:
            let location = LocationManager()
            location.locationType = .always
            manager = location
        }
        
        return manager.status
    }
}

extension Please {
    public static func allow(_ type: PermissionRequestType, handler: @escaping Please.Reply) {
        var manager = type.manager
        manager.request(handler: handler)
    }
}

extension Please {
    public struct Camera: PermissionContext {
        public let softAskView: SoftAskView?
        public let deniedAlert: DeniedAlert?
        
        public init (softAskView: SoftAskView?, deniedAlert: DeniedAlert?) {
            self.softAskView = softAskView
            self.deniedAlert = deniedAlert
        }
        
        public static let `default` = Camera(softAskView: .init(title: "Allow Camera"), deniedAlert: nil)
    }
    
    public struct PhotoLibrary: PermissionContext {
        public let softAskView: SoftAskView?
        public let deniedAlert: DeniedAlert?
        
        public init (softAskView: SoftAskView?, deniedAlert: DeniedAlert?) {
            self.softAskView = softAskView
            self.deniedAlert = deniedAlert
        }
        
        public var permissionType: PermissionManagerType { .photoLibrary }

        public static let `default` = PhotoLibrary(softAskView: .init(title: "Allow Photo Library"), deniedAlert: nil)
    }
    
    public struct Contacts: PermissionContext {
        public let softAskView: SoftAskView?
        public let deniedAlert: DeniedAlert?
        
        public init (softAskView: SoftAskView?, deniedAlert: DeniedAlert?) {
            self.softAskView = softAskView
            self.deniedAlert = deniedAlert
        }
        
        public var permissionType: PermissionManagerType { .contacts }

        public static let `default` = Contacts(softAskView: .init(title: "Allow Contact"), deniedAlert: nil)
    }
    
    public struct Location: PermissionContext {
        public let requestType: LocationRequestType
        public let softAskView: SoftAskView?
        public let deniedAlert: DeniedAlert?
        
        public init (requestType: LocationRequestType, softAskView: SoftAskView?, deniedAlert: DeniedAlert?) {
            self.requestType = requestType
            self.softAskView = softAskView
            self.deniedAlert = deniedAlert
        }

        public static let `default` = Location(requestType: .whenInUse, softAskView: .init(title: "Allow Contact"), deniedAlert: nil)
    }
    
    public struct Notifications: PermissionContext {
        public let softAskView: SoftAskView?
        public let deniedAlert: DeniedAlert?
        
        public init (softAskView: SoftAskView?, deniedAlert: DeniedAlert?) {
            self.softAskView = softAskView
            self.deniedAlert = deniedAlert
        }
        
        public var permissionType: PermissionManagerType { .notifications }

        public static let `default` = Notifications(softAskView: .init(title: "Allow Notifications"), deniedAlert: nil)
    }
}
