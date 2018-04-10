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
            return "Please allow access to your contacts to invite people."
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
            return "Contact Permission has been denied. Please open Settings and allow access to your contacts to invite people."
        case .push:
            return "Open settings and allow us to send you Push Notifications to keep you updated."
        }
    }
    
    var softAskView: SoftAskView {
        let view = SoftAskView(.fullScreen)
        view.allowButtonBackgroundColor = view.denyButtonTitleColor
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
    
    func request(handler: @escaping Please.Reply) {
        let tracker = PermissionTracker()
        
        switch self {
        case .camera:
            Please.allow.camera(softAskView: softAskView, deniedView: deniedView, tracker: tracker, completion: handler)
        
        case .photoLibrary:
            Please.allow.photoLibrary(softAskView: softAskView, deniedView: deniedView, tracker: tracker, completion: handler)
        
        case .locationWhenInUse:
            Please.allow.location.whenInUse(softAskView: softAskView, deniedView: deniedView, tracker: tracker, completion: handler)
            
        case .locationAlways:
            Please.allow.location.always(softAskView: softAskView, deniedView: deniedView, tracker: tracker, completion: handler)
            
        case .contacts:
            Please.allow.contacts(softAskView: softAskView, deniedView: deniedView, tracker: tracker, completion: handler)
            
        case .push:
            Please.allow.push(softAskView: softAskView, deniedView: deniedView, tracker: tracker, completion: handler)
        }
    }
}

class PermissionTracker: PleaseAllowTracker {
    func track(_ action: Please.Action) {
        print(action.stringValue)
    }
}

@objc
class PermissionRequester: NSObject {
    @objc
    static func request(_ permission: PermissionType, handler: @escaping Please.Reply) {
        permission.request(handler: handler)
    }
}
