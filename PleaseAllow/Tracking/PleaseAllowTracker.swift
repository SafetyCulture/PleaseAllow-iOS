//
//  PleaseAllowTracker.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

public protocol PleaseAllowTracker {
    func track(_ action: Please.Action)
}

extension Please {
    
    /**
     ## PleaseAllow.Action ##
     
     Can be used to track every move a manager makes.
     
     */
    public enum Action {
        
        /// Called when the *request` method is first called on a Permission Manager
        case beganRequest(PermissionManagerType)
        
        /// Called when a requested permission is already authorised.
        case alreadyAuthorized(PermissionManagerType)
        
        /// Called when the *SoftAskView` is presented for a Permission Manager.
        case softViewPresented(PermissionManagerType)
        
        /// Called when the Deny button is tapped on the *SoftAskView* for a Permission Manager.
        case softAskDenied(PermissionManagerType)
        
        /// Called when the Allow button is tapped on the *SoftAskView* for a Permission Manager.
        case softAskAllowed(PermissionManagerType)
        
        /// Called when the iOS permission alert is presented for a Permission Manager.
        case hardAskPresented(PermissionManagerType)
        
        /// Called when the iOS permission is Allowed for a Permission Manager.
        case hardAskAllowed(PermissionManagerType)
        
        /// Called when the iOS permission is Denied for a Permission Manager.
        case hardAskDenied(PermissionManagerType)
        
        /// Called when the *DeniedAlert8 is presented for a Permission Manager.
        case deniedAlertPresented(PermissionManagerType)
        
        /// Called when the Cancel button is tapped on the *DeniedAlert* for a Permission Manager.
        case deniedAlertDismissed(PermissionManagerType)
        
        
        /// Called when the Settings button is tapped on the *DeniedAlert* for a Permission Manager.
        case redirectedToSettings(PermissionManagerType)
        
        /// Called when an error occurs during the request for a Permission Manager.
        case error(PermissionManagerType, Error?)
        
        
        /// Returns the *PermissionManagerType* for the current Action.
        public var permissionManagerType: PermissionManagerType {
            switch self {
            case .beganRequest(let type):
                return type
            case .alreadyAuthorized(let type):
                return type
            case .softViewPresented(let type):
                return type
            case .softAskDenied(let type):
                return type
            case .softAskAllowed(let type):
                return type
            case .hardAskPresented(let type):
                return type
            case .hardAskAllowed(let type):
                return type
            case .hardAskDenied(let type):
                return type
            case .deniedAlertPresented(let type):
                return type
            case .deniedAlertDismissed(let type):
                return type
            case .redirectedToSettings(let type):
                return type
            case .error(let type, _):
                return type
            }
        }
    }
}
