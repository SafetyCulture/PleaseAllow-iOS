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
open class Please: NSObject {
    internal var activeManager: PermissionManager!
    
    public static let allow = Please()
    public var location = LocationPlease()
}

extension Please {
    
    /// Requests for Camera Permission
    public func camera(softAskView: SoftAskView? = nil, deniedView: DeniedAlert? = nil, tracker: PleaseAllowTracker? = nil, completion: @escaping Please.Reply) {
        activeManager = Camera()
        request(softAskView: softAskView, deniedView: deniedView, tracker: tracker, completion: completion)
    }
    
    /// Requests for Photo Library Permission
    public func photoLibrary(softAskView: SoftAskView? = nil, deniedView: DeniedAlert? = nil, tracker: PleaseAllowTracker? = nil, completion: @escaping Please.Reply) {
        activeManager = PhotoLibrary()
        request(softAskView: softAskView, deniedView: deniedView, tracker: tracker, completion: completion)
    }

    /// Requests for Contacts Permission
    public func contacts(softAskView: SoftAskView? = nil, deniedView: DeniedAlert? = nil, tracker: PleaseAllowTracker? = nil, completion: @escaping Please.Reply) {
        activeManager = Contacts()
        request(softAskView: softAskView, deniedView: deniedView, tracker: tracker, completion: completion)
    }

    /// Requests for Push Notification Permissions. Note: Does not present the System Permission alert. Soft Ask will return `.allowed` or `.softDenial`
    public func push(softAskView: SoftAskView? = nil, deniedView: DeniedAlert? = nil, tracker: PleaseAllowTracker? = nil, completion: @escaping Please.Reply) {
        activeManager = PushNotifications()
        request(softAskView: softAskView, deniedView: deniedView, tracker: tracker, completion: completion)
    }

    /// Contains the Always & When In Use Permission Managers for location permissions.
    public struct LocationPlease {

        /// Requests for When In Use Lcoation Permission
        public func whenInUse(softAskView: SoftAskView? = nil, deniedView: DeniedAlert? = nil, tracker: PleaseAllowTracker? = nil, completion: @escaping Please.Reply) {
            Please.allow.activeManager = {
                let location = Location()
                location.softAskView = softAskView
                location.locationType = .whenInUse
                location.type = .locationWhenInUse
                return location
            }()
            Please.allow.request(softAskView: softAskView, deniedView: deniedView, tracker: tracker, completion: completion)
        }

        /// Requests for Always Location Permission. Note: Will return `.notDetermined` if 'When In Use location' is authorized.
        public func always(softAskView: SoftAskView? = nil, deniedView: DeniedAlert? = nil, tracker: PleaseAllowTracker? = nil, completion: @escaping Please.Reply) {
            Please.allow.activeManager = {
                let location = Location()
                location.locationType = .always
                location.type = .locationAlways
                return location
            }()
            Please.allow.request(softAskView: softAskView, deniedView: deniedView, tracker: tracker, completion: completion)
        }
    }
}

extension Please {
    fileprivate func request(softAskView: SoftAskView?, deniedView: DeniedAlert?, tracker: PleaseAllowTracker?, completion: @escaping Please.Reply) {
        activeManager.softAskView = softAskView
        activeManager.deniedAlert = deniedView
        activeManager.tracker = tracker
        activeManager.request(handler: completion)
    }
}
