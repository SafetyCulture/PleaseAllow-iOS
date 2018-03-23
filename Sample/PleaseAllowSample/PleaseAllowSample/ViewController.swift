//
//  ViewController.swift
//  PleaseAllowSample
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import UIKit
import PleaseAllow
import UserNotifications

class ViewController: UIViewController {
    
    
    @IBAction func allowCamera(_ sender: Any) {
        PermissionType.camera.request { result, error in
            print("\(result)")
        }
    }
    
    @IBAction func allowPhotoLibrary(_ sender: Any) {
        PermissionType.photoLibrary.request { result, error in
            print("\(result)")
        }
    }
    
    @IBAction func allowContacts(_ sender: Any) {
        PermissionType.contacts.request { result, error in
            print("\(result)")
        }
    }
    
    @IBAction func allowLocationWhenInUse(_ sender: Any) {
        PermissionType.locationWhenInUse.request { result, error in
            print("\(result)")
        }
    }
    
    @IBAction func allowLocationAlways(_ sender: Any) {
        PermissionType.locationAlways.request { result, error in
            print("\(result)")
        }
    }
    
    @IBAction func allowPushNotification(_ sender: Any) {
        PermissionType.push.request { result, error in
            guard !UIApplication.shared.isRegisteredForRemoteNotifications else { return }
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in
                DispatchQueue.main.sync {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

@objc enum PermissionType: Int {
    case camera = 0, photoLibrary, contacts, locationWhenInUse, locationAlways, push
    
    var allowTitle: String {
        return "Allow"
    }
    
    var denyTitle: String {
        return "Don't Allow"
    }
    
    var settings: String {
        return "Settings"
    }
    
    var cancel: String {
        return "Cancel"
    }
    
    var title: String {
        switch self {
        case .camera:
            return "Allow Camera"
        case .photoLibrary:
            return "Allow Photo Library"
        case .locationWhenInUse:
            return "Allow Location"
        case .locationAlways:
            return "Allow Location"
        case .contacts:
            return "Allow Contacts"
        case .push:
            return "Allow Push Notifications"
        }
    }
    
    var description: String {
        switch self {
        case .camera:
            return "Allow access to your Camera in order to add images to your work."
        case .photoLibrary:
            return "Allow access to your Photo Library in order to add images to your work."
        case .locationWhenInUse:
            return "Allow access to your Lcoation in order to add current location to your work."
        case .locationAlways:
            return "Allow access to your Lcoation in order to add current location to your work."
        case .contacts:
            return "Allow access to your Contacts in order to collaborate with others on your work."
        case .push:
            return "Allow us to send you Push Notifications to keep you updated."
        }
    }
    
    var deniedTitle: String {
        switch self {
        case .camera:
            return "Camera Denied"
        case .photoLibrary:
            return "Photo Library Denied"
        case .locationWhenInUse:
            return "Location Denied"
        case .locationAlways:
            return "Location Denied"
        case .contacts:
            return "Contacts Denied"
        case .push:
            return "Push Notifications Denied"
        }
    }
    
    var deniedDescription: String {
        switch self {
        case .camera:
            return "Open settings and allow access to your Camera in order to add images to your work."
        case .photoLibrary:
            return "Open settings and allow access to your Photo Library in order to add images to your work."
        case .locationWhenInUse:
            return "Open settings and allow access to your Lcoation in order to add current location to your work."
        case .locationAlways:
            return "Open settings and allow access to your Lcoation in order to add current location to your work."
        case .contacts:
            return "Open settings and allow access to your Contacts in order to collaborate with others on your work."
        case .push:
            return "Open settings and allow us to send you Push Notifications to keep you updated."
        }
    }
    
    var softAskView: SoftAskView {
        let view = SoftAskView(.fullScreen)
        view.allowButtonBackgroundColor = .blue
        view.allowButtonTitleColor = .white
        view.allowButtonTitle = allowTitle
        view.denyButtonTitle = denyTitle
        view.title = title
        view.description = description
        return view
    }
    
    var deniedView: DeniedAlert {
        let view = DeniedAlert(.modal)
        view.allowButtonTitle = settings
        view.denyButtonTitle = cancel
        view.title = deniedTitle
        view.description = deniedDescription
        return view
    }
    
    func request(handler: @escaping PleaseAllowReply) {
        let tracker = PermissionTracker()
        
        switch self {
        case .camera:
            PleaseAllow.Managers.camera.softAskView = PermissionType.camera.softAskView
            PleaseAllow.Managers.camera.deniedAlert = PermissionType.camera.deniedView
            PleaseAllow.camera(tracker: tracker, completion: handler)
        
        case .photoLibrary:
            PleaseAllow.Managers.photoLibrary.softAskView = PermissionType.photoLibrary.softAskView
            PleaseAllow.Managers.photoLibrary.deniedAlert = PermissionType.photoLibrary.deniedView
            PleaseAllow.photoLibrary(tracker: tracker, completion: handler)
        
        case .locationWhenInUse:
            PleaseAllow.Managers.location.whenInUse.softAskView = PermissionType.locationWhenInUse.softAskView
            PleaseAllow.Managers.location.whenInUse.deniedAlert = PermissionType.locationWhenInUse.deniedView
            PleaseAllow.location.whenInUse(tracker: tracker, completion: handler)
            
        case .locationAlways:
            PleaseAllow.Managers.location.always.softAskView = PermissionType.locationAlways.softAskView
            PleaseAllow.Managers.location.always.deniedAlert = PermissionType.locationAlways.deniedView
            PleaseAllow.location.always(tracker: tracker, completion: handler)
            
        case .contacts:
            PleaseAllow.Managers.contacts.softAskView = PermissionType.contacts.softAskView
            PleaseAllow.Managers.contacts.deniedAlert = PermissionType.contacts.deniedView
            PleaseAllow.contacts(tracker: tracker, completion: handler)
            
        case .push:
            PleaseAllow.Managers.push.softAskView = PermissionType.push.softAskView
            PleaseAllow.Managers.push.deniedAlert = PermissionType.push.deniedView
            PleaseAllow.push(tracker: tracker, completion: handler)
        }
    }
}

class PermissionTracker: PleaseAllowTracker {
    func track(_ action: PleaseAllow.Action) {
        print(action.stringValue)
    }
}

@objc
class PermissionRequester: NSObject {
    @objc
    static func request(_ permission: PermissionType, handler: @escaping PleaseAllowReply) {
        permission.request(handler: handler)
    }
}
