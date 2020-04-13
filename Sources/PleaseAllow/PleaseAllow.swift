//
//  PleaseAllow.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import Foundation
import UserNotifications


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
        case .notifications(let notificationContext):
            let notificationsManager = NotificationsManager()
            notificationsManager.requestOptions = notificationContext.options
            activeManager = notificationsManager
        }
        
        activeManager.softAsk = context.softAsk
        activeManager.deniedAlert = context.deniedAlert
        return activeManager
    }
}

public protocol PermissionContext {
    var softAsk: SoftAsk? { get }
    var deniedAlert: DeniedAlert? { get }
}

open class Please: NSObject {
    /// Shared Instance to be used for all permission requests.
    
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

extension Please {
    public static func allow(_ type: PermissionRequestType, eventListener: PleaseAllowEventListener? = nil, handler: Please.Reply?) {
        var manager = type.manager
        manager.eventListener = eventListener
        manager.request(handler: handler)
    }
}

extension Please {
    public struct Camera: PermissionContext {
        public let softAsk: SoftAsk?
        public let deniedAlert: DeniedAlert?
        
        public init (softAsk: SoftAsk?, deniedAlert: DeniedAlert?) {
            self.softAsk = softAsk
            self.deniedAlert = deniedAlert
        }
        
        public static let `default` = Camera(softAsk: .init(title: "Allow Camera"), deniedAlert: nil)
    }
    
    public struct PhotoLibrary: PermissionContext {
        public let softAsk: SoftAsk?
        public let deniedAlert: DeniedAlert?
        
        public init (softAsk: SoftAsk?, deniedAlert: DeniedAlert?) {
            self.softAsk = softAsk
            self.deniedAlert = deniedAlert
        }

        public static let `default` = PhotoLibrary(softAsk: .init(title: "Allow Photo Library"), deniedAlert: nil)
    }
    
    public struct Contacts: PermissionContext {
        public let softAsk: SoftAsk?
        public let deniedAlert: DeniedAlert?
        
        public init (softAsk: SoftAsk?, deniedAlert: DeniedAlert?) {
            self.softAsk = softAsk
            self.deniedAlert = deniedAlert
        }

        public static let `default` = Contacts(softAsk: .init(title: "Allow Contact"), deniedAlert: nil)
    }
    
    public struct Location: PermissionContext {
        public let requestType: LocationRequestType
        public let softAsk: SoftAsk?
        public let deniedAlert: DeniedAlert?
        
        public init (requestType: LocationRequestType, softAsk: SoftAsk?, deniedAlert: DeniedAlert?) {
            self.requestType = requestType
            self.softAsk = softAsk
            self.deniedAlert = deniedAlert
        }

        public static let `default` = Location(requestType: .whenInUse, softAsk: .init(title: "Allow Contact"), deniedAlert: nil)
    }
    
    public struct Notifications: PermissionContext {
        public let options: UNAuthorizationOptions
        public let softAsk: SoftAsk?
        public let deniedAlert: DeniedAlert?
        
        public init (options: UNAuthorizationOptions, softAsk: SoftAsk?, deniedAlert: DeniedAlert?) {
            self.options = options
            self.softAsk = softAsk
            self.deniedAlert = deniedAlert
        }

        public static let `default` = Notifications(options: [.alert, .sound], softAsk: .init(title: "Allow Notifications"), deniedAlert: nil)
    }
}
