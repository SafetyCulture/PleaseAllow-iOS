//
//  RequestManager.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import Foundation

/// Internal protocol for all Permission Manager to handle requests
@objc internal protocol RequestManager: class {
    
    /// Presents the iOS permission dialogue
    func requestHardPermission()
    
    /// Called when the Allow button is tapped on the `SoftAsk`. Proceeds to present the iOS permission dialogue
    @objc func softPermissionGranted()
    
    /// Called whent he Deny button is tapped on the `SoftAsk`.
    @objc func softPermissionDenied()
}

