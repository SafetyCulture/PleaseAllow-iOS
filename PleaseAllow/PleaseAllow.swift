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
    /// Shared Instance to be used for all permission requests.
    public static let allow = Please()
    public var location = LocationPlease()
    internal var activeManager: PermissionManager!
    
    public static func shareStatus(for managerType: PermissionManagerType) -> PermissionStatus {
        var manager: PermissionManager!
        switch managerType {
        case .camera:
            manager = Camera()
        case .photoLibrary:
            manager = PhotoLibrary()
        case .contacts:
            manager = Contacts()
        case .notifications:
            manager = Notifications()
        case .locationWhenInUse:
            let location = Location()
            location.locationType = .whenInUse
            manager = location
        case .locationAlways:
            let location = Location()
            location.locationType = .always
            manager = location
        }
        
        return manager.status
    }
}

extension Please {
    
    /// Requests for Camera Permission/
    public func camera(softAskView: SoftAskView? = nil, deniedView: DeniedAlert? = nil, eventListener: PleaseAllowEventListener? = nil, completion: @escaping Please.Reply) {
        activeManager = Camera()
        request(softAskView: softAskView, deniedView: deniedView, eventListener: eventListener, completion: completion)
    }
    
    /// Requests for Photo Library Permission/
    public func photoLibrary(softAskView: SoftAskView? = nil, deniedView: DeniedAlert? = nil, eventListener: PleaseAllowEventListener? = nil, completion: @escaping Please.Reply) {
        activeManager = PhotoLibrary()
        request(softAskView: softAskView, deniedView: deniedView, eventListener: eventListener, completion: completion)
    }

    /// Requests for Contacts Permission/
    public func contacts(softAskView: SoftAskView? = nil, deniedView: DeniedAlert? = nil, eventListener: PleaseAllowEventListener? = nil, completion: @escaping Please.Reply) {
        activeManager = Contacts()
        request(softAskView: softAskView, deniedView: deniedView, eventListener: eventListener, completion: completion)
    }

    /// Requests for Notification Permissions. Note: Does not present the System Permission alert. Soft Ask will return `.allowed` or `.softDenial`/
    public func notifications(softAskView: SoftAskView? = nil, deniedView: DeniedAlert? = nil, eventListener: PleaseAllowEventListener? = nil, completion: @escaping Please.Reply) {
        activeManager = Notifications()
        request(softAskView: softAskView, deniedView: deniedView, eventListener: eventListener, completion: completion)
    }

    /// Contains the Always & When In Use Permission Managers for location permissions.
    public struct LocationPlease {

        /// Requests for When In Use Lcoation Permission/
        public func whenInUse(softAskView: SoftAskView? = nil, deniedView: DeniedAlert? = nil, eventListener: PleaseAllowEventListener? = nil, completion: @escaping Please.Reply) {
            Please.allow.activeManager = {
                let location = Location()
                location.softAskView = softAskView
                location.locationType = .whenInUse
                location.type = .locationWhenInUse
                return location
            }()
            Please.allow.request(softAskView: softAskView, deniedView: deniedView, eventListener: eventListener, completion: completion)
        }

        /// Requests for Always Location Permission. Note: Will return `.notDetermined` if 'When In Use location' is authorized.
        public func always(softAskView: SoftAskView? = nil, deniedView: DeniedAlert? = nil, eventListener: PleaseAllowEventListener? = nil, completion: @escaping Please.Reply) {
            Please.allow.activeManager = {
                let location = Location()
                location.locationType = .always
                location.type = .locationAlways
                return location
            }()
            Please.allow.request(softAskView: softAskView, deniedView: deniedView, eventListener: eventListener, completion: completion)
        }
    }
}

extension Please {
    fileprivate func request(softAskView: SoftAskView?, deniedView: DeniedAlert?, eventListener: PleaseAllowEventListener?, completion: @escaping Please.Reply) {
        activeManager.softAskView = softAskView
        activeManager.deniedAlert = deniedView
        activeManager.eventListener = eventListener
        activeManager.request(handler: completion)
    }
}
