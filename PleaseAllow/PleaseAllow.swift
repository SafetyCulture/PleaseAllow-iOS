//
//  PleaseAllow.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import Foundation


/**
 A *humorous* take for requesting iOS Permissions.
 
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
open class PleaseAllow: NSObject {
    
    public  struct Managers {
        /// Permission Manager for Camera Permissions
        public static var camera: PermissionManager = Camera()
        
        /// Permission Manager for Contacts Permissions
        public static var contacts: PermissionManager = Contacts()
    
        /// Permission Manager for Photo Library Permissions
        public static var photoLibrary: PermissionManager = PhotoLibrary()
    
        /// Permission Manager for Push Notification Permissions
        public static var push: PermissionManager = PushNotifications()
    
        /// Contains Permission Managers for Location Permissions
        public struct location {
    
            /// Permission Manager for Always Location Permissions
            public static var always: PermissionManager = {
                let location = Location()
                location.locationType = .always
                location.type = .locationAlways
                return location
            }()
    
            /// Permission Manager for When In Use Location Permissions
            public static var whenInUse: PermissionManager = {
                let location = Location()
                location.locationType = .whenInUse
                location.type = .locationWhenInUse
                return location
            }()
        }
    }
}

extension PleaseAllow {
        
    public static func camera(tracker: PleaseAllowTracker? = nil, completion: @escaping PleaseAllowReply) {
        PleaseAllow.Managers.camera.tracker = tracker
        PleaseAllow.Managers.camera.request(handler: completion)
    }
    
    public static func photoLibrary(tracker: PleaseAllowTracker? = nil, completion: @escaping PleaseAllowReply) {
        PleaseAllow.Managers.photoLibrary.tracker = tracker
        PleaseAllow.Managers.photoLibrary.request(handler: completion)
    }

    public static func contacts(tracker: PleaseAllowTracker? = nil, completion: @escaping PleaseAllowReply) {
        PleaseAllow.Managers.contacts.tracker = tracker
        PleaseAllow.Managers.contacts.request(handler: completion)
    }

    public static func push(tracker: PleaseAllowTracker? = nil, completion: @escaping PleaseAllowReply) {
        PleaseAllow.Managers.push.request(handler: completion)
    }

    public struct location {

        public static func whenInUse(tracker: PleaseAllowTracker? = nil, completion: @escaping PleaseAllowReply) {
            PleaseAllow.Managers.location.whenInUse.tracker = tracker
            PleaseAllow.Managers.location.whenInUse.request(handler: completion)
        }

        public static func always(tracker: PleaseAllowTracker? = nil, completion: @escaping PleaseAllowReply) {
            PleaseAllow.Managers.location.always.tracker = tracker
            PleaseAllow.Managers.location.always.request(handler: completion)
        }
    }
}
