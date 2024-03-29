//
//  PleaseAllowResult.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import Foundation

extension Please {

    /**
     Completion Handler for a permission request.
     
     - parameters:
     - reply:
     type of `Please.Reply`.
     - error:
     if an error occurs during the request.
     
     - returns: void
     */
    public typealias Reply = (_ reply: Please.Result, _ error: Error?) -> ()

    /**
     Returned in the Completion handler of the request for a Permission
     */
    @objc public enum Result: NSInteger {
        
        /// Returned when the user authorises usage for the requested permission.
        case allowed
        
        /// Returned when the user taps on the Deny button on the `SoftAskView`
        case softDenial
        
        /// Returned when the user taps on the Deny button on the iOS Permission alert.
        case hardDenial
        
        /// Returned when the Permission Manager for the requested permission is Restriced on the device.
        case restricted
        
        /// Returned when the Permission Manager for the requested permission is Unavailable.
        case unavailable
        
        /// Returned when the denied alert is shown and the user chose to open Settings.
        case redirectedToSettings
        
        /// Returned when the user taps on "Select some photos"
        case limited
    }
}

