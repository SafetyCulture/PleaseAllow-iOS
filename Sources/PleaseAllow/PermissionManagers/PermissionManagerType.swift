//
//  PermissionManagerType.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import Foundation

/// Types of Permission Managers
public enum PermissionManagerType {
    case camera
    case contacts
    case photoLibrary
    case location(LocationRequestType)
    case notifications
    
    /// A string representation of each *ManagerType*
    public var name: String {
        switch self {
        case .camera: return "Camera"
        case .contacts: return "Contacts"
        case .photoLibrary: return "Photo Library"
        case .location(let type):
            switch type {
                case .always: return "Location When In Use"
                case .whenInUse: return "Location Always"
            }
        case .notifications: return "Notifications"
        }
    }
}


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
