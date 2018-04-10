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
     case .allowed     : print("Authorized")
     case .softDenial  : print("Denied Soft")
     case .hardDenial  : print("Denied Hard")
     case .restricted  : print("Restricted")
     case .unavailable : print("Unavailable")
     }
 }
 ```
  
 */
open class Please: NSObject {
    public static let allow = Please()
    public var location: LocationPlease = .init()
    internal var activeManager: PermissionManager!
}

extension Please {
    private func request(softAskView: SoftAskView?, deniedView: DeniedAlert?, tracker: PleaseAllowTracker?, completion: @escaping Please.Reply) {
        activeManager.softAskView = softAskView
        activeManager.deniedAlert = deniedView
        activeManager.tracker = tracker
        activeManager.request(handler: completion)
    }
    
    public func camera(softAskView: SoftAskView? = nil, deniedView: DeniedAlert? = nil, tracker: PleaseAllowTracker? = nil, completion: @escaping Please.Reply) {
        activeManager = Camera()
        request(softAskView: softAskView, deniedView: deniedView, tracker: tracker, completion: completion)
    }
    
    public func photoLibrary(softAskView: SoftAskView? = nil, deniedView: DeniedAlert? = nil, tracker: PleaseAllowTracker? = nil, completion: @escaping Please.Reply) {
        activeManager = PhotoLibrary()
        request(softAskView: softAskView, deniedView: deniedView, tracker: tracker, completion: completion)
    }

    public func contacts(softAskView: SoftAskView? = nil, deniedView: DeniedAlert? = nil, tracker: PleaseAllowTracker? = nil, completion: @escaping Please.Reply) {
        activeManager = Contacts()
        request(softAskView: softAskView, deniedView: deniedView, tracker: tracker, completion: completion)
    }

    public func push(softAskView: SoftAskView? = nil, deniedView: DeniedAlert? = nil, tracker: PleaseAllowTracker? = nil, completion: @escaping Please.Reply) {
        activeManager = PushNotifications()
        request(softAskView: softAskView, deniedView: deniedView, tracker: tracker, completion: completion)
    }

    public struct LocationPlease {

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
