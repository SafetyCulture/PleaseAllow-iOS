//
//  PermissionManagerType.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import Foundation

/// Types of Permission Managers
public enum PermissionManagerType: String {
    case camera
    case contacts
    case photoLibrary
    case location
    case pushNotifications
    
    /// A string representation of each *ManagerType*
    public var name: String {
        switch self {
        case .camera: return "Camera"
        case .contacts: return "Contacts"
        case .photoLibrary: return "Photo Library"
        case .location: return "Location"
        case .pushNotifications: return "Push Notifications"
        }
    }
}

