//
//  PleaseAllowTracker.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

public protocol PleaseAllowEventListener {
    func pleaseAllowPermissionManager(_ manager: PermissionManager, didPerformAction action: Please.Action)
}

extension Please {
    
    /**
     ## PleaseAllow.Action ##
     
     Can be used to track every move a manager makes.
     
     */
    public enum Action: String {
        
        /// Called when the *request` method is first called on a Permission Manager
        case beganRequest
        
        /// Called when a requested permission is already authorised.
        case alreadyAuthorized
        
        /// Called when the *SoftAskView` is presented for a Permission Manager.
        case softAskViewPresented
        
        /// Called when the Deny button is tapped on the *SoftAskView* for a Permission Manager.
        case softAskDenied
        
        /// Called when the Allow button is tapped on the *SoftAskView* for a Permission Manager.
        case softAskAllowed
        
        /// Called when the iOS permission alert is presented for a Permission Manager.
        case hardAskPresented
        
        /// Called when the iOS permission is Allowed for a Permission Manager.
        case hardAskAllowed
        
        /// Called when the iOS permission is Denied for a Permission Manager.
        case hardAskDenied
        
        /// Called when the *DeniedAlert8 is presented for a Permission Manager.
        case deniedAlertPresented
        
        /// Called when the Cancel button is tapped on the *DeniedAlert* for a Permission Manager.
        case deniedAlertDismissed
        
        /// Called when the Settings button is tapped on the *DeniedAlert* for a Permission Manager.
        case redirectedToSettings
    }
}
