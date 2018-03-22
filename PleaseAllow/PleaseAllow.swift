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
 BabyPlease.allow.location.always { whatBabySaid, eror in
 switch whatBabySaid {
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
    
    struct Managers {
        /// Permission Manager for Camera Permissions
        public static var camera: PermissionManager = Camera()
        
        /// Permission Manager for Contacts Permissions
    //    public static var contacts: PermissionManager = Contacts()
    //
    //    /// Permission Manager for Photo Library Permissions
    //    public static var photoLibrary: PermissionManager = PhotoLibrary()
    //
    //    /// Permission Manager for Push Notification Permissions
    //    public static var push: PermissionManager = PushNotifications()
    //
    //    /// Contains Permission Managers for Location Permissions
    //    public struct location {
    //
    //        /// Permission Manager for Always Location Permissions
    //        public static var always   : PermissionManager = {
    //            let location = Location()
    //            location.locationType = .always
    //            location.type = .locationAlways
    //            return location
    //        }()
    //
    //        /// Permission Manager for When In Use Location Permissions
    //        public static var whenInUse: PermissionManager = {
    //            let location = Location()
    //            location.locationType = .whenInUse
    //            location.type = .locationWhenInUse
    //            return location
    //        }()
    //    }
    }
}

extension PleaseAllow {
        
    public static func camera(softAskView: SoftAskView? = nil, deniedAlert: DeniedAlert? = nil, tracker: PleaseAllowTracker? = nil, completion: @escaping PleaseAllowReply) {
        PleaseAllow.Managers.camera.tracker = tracker
        PleaseAllow.Managers.camera.request(softAsk: softAskView, alert: deniedAlert) { (reply, error) in
            completion(reply, error)
        }
    }
    
//    public static func photoLibrary(softAskView: SoftAskView, deniedAlert: DeniedAlert? = nil, tracker: PleaseAllowTracker? = nil, completion: @escaping PleaseAllowReply) {
//        BabyPlease.photoLibrary.tracker = tracker
//        BabyPlease.photoLibrary.request(softAsk: softAskView, alert: deniedAlert) { (reply, error) in
//            completion(reply, error)
//        }
//    }
//
//    public static func contacts(softAskView: SoftAskView, deniedAlert: DeniedAlert? = nil, tracker: PleaseAllowTracker? = nil, completion: @escaping PleaseAllowReply) {
//        BabyPlease.contacts.tracker = tracker
//        BabyPlease.contacts.request(softAsk: softAskView, alert: deniedAlert) { (reply, error) in
//            completion(reply, error)
//        }
//    }
//
//    public static func push(softAskView: SoftAskView, deniedAlert: DeniedAlert? = nil, tracker: PleaseAllowTracker? = nil) {
//        BabyPlease.push.request(softAsk: softAskView, alert: deniedAlert)
//    }
//
//    public struct location {
//
//        public static func whenInUse(softAskView: SoftAskView, deniedAlert: DeniedAlert? = nil, tracker: PleaseAllowTracker? = nil, completion: @escaping PleaseAllowReply) {
//            BabyPlease.location.whenInUse.tracker = tracker
//            BabyPlease.location.whenInUse.request(softAsk: softAskView, alert: deniedAlert) { (reply, error) in
//                completion(reply, error)
//            }
//        }
//
//        public static func always(softAskView: SoftAskView, deniedAlert: DeniedAlert? = nil, tracker: PleaseAllowTracker? = nil, completion: @escaping PleaseAllowReply) {
//            BabyPlease.location.always.tracker = tracker
//            BabyPlease.location.always.request(softAsk: softAskView, alert: deniedAlert) { (reply, error) in
//                completion(reply, error)
//            }
//        }
//    }
}
