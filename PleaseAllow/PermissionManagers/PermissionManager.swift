//
//  PermissionManager.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import Foundation

/// Common Protocol for all Permissions
public protocol PermissionManager {
    /// Returns the `MangerType` for the current Permission Manager
    var type            : PermissionManagerType      { get }
    
    /// Returns the `PermissionStatus` for the current Permission Manager.
    var status          : PermissionStatus { get }
    
    /// Returns if the `PermissionManager` is available on the current device.
    var isAvailable     : Bool             { get }
    
    /// Returns if the `PermissionManager` is able to request authorization.
    var canRequest      : Bool             { get }
    
    /// Use the properties of this `softAskView` for customization.
    var softAskView     : SoftAskView?     { get set }
    
    /**
     Uses the `softAskView` to show a `DeniedAlert` if the requestd permission was denied previosuly.
     - Customise the alert properties using this instance.
     - Also set properties of the `softAskView` for further customization.
     */
    var deniedAlert     : DeniedAlert?     { get set }
    
    /// The completion for the request method
    var resultHandler   : Please.Reply?   { get set }
    
    var eventListener   : PleaseAllowEventListener? { get set }
}

extension PermissionManager {
    
    //MARK:- Can Request
    
    var canRequest: Bool {
        guard let handler = resultHandler else { return false }
        
        switch status {
        case .authorized:
            eventListener?.pleaseAllowPermissionManager(self, didPerformAction: .alreadyAuthorized)
            handler(.allowed, nil)
            
        case .denied:
            if let deniedAlert = deniedAlert {
                eventListener?.pleaseAllowPermissionManager(self, didPerformAction: .deniedAlertPresented)
                deniedAlert.present(for: self)
            }
            
            handler(.hardDenial, nil)
            
        case .restricted:
            handler(.restricted, nil)
            
        case .limited:
            handler(.limited, nil)
            
        case .unavailable:
            handler(.unavailable, nil)
            
        case .notDetermined:
            return true
        }
        
        return false
    }
    
    //MARK:- Request
    
    /**
     The request method for `PermisssionManager`
     
     - parameters:
     - handler:
     The completion to be called when the request manager is finished with the request
     */
    
    internal mutating func request(handler: Please.Reply? = nil) {
        resultHandler = handler
        guard isAvailable && canRequest else { return }
        
        eventListener?.pleaseAllowPermissionManager(self, didPerformAction: .beganRequest)
        guard softAskView == nil else {
            softAskView?.present(for: self)
            eventListener?.pleaseAllowPermissionManager(self, didPerformAction: .softAskViewPresented)
            return
        }
        
        eventListener?.pleaseAllowPermissionManager(self, didPerformAction: .hardAskPresented)
        guard let requestManager = self as? RequestManager else { return }
        requestManager.requestHardPermission()
    }
    
    func redirectToSettings() {
        resultHandler?(.redirectedToSettings, nil)
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.openURL(url)
        }
    }
}
