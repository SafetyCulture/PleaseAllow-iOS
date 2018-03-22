//
//  PermissionManagerType.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import Foundation

/// Types of Permission Managers
@objc public enum PermissionManagerType: Int {
    case camera
    case contacts
    case photoLibrary
    case locationWhenInUse
    case locationAlways
    case pushNotifications
    
    /// A string representation of each *ManagerType*
    public var name: String {
        switch self {
        case .camera: return "Camera"
        case .contacts: return "Contacts"
        case .photoLibrary: return "Photo Library"
        case .locationWhenInUse: return "Location When In Use"
        case .locationAlways: return "Location Always"
        case .pushNotifications: return "Push Notifications"
        }
    }
}

