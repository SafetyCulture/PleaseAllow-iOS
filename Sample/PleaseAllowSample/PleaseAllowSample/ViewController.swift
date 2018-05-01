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
        Permission.camera.request { result, error in
            print("\(result)")
        }
    }
    
    @IBAction func allowPhotoLibrary(_ sender: Any) {
        Permission.photoLibrary.request { result, error in
            print("\(result)")
        }
    }
    
    @IBAction func allowContacts(_ sender: Any) {
        Permission.contacts.request { result, error in
            print("\(result)")
        }
    }
    
    @IBAction func allowLocationWhenInUse(_ sender: Any) {
        Permission.locationWhenInUse.request { result, error in
            print("\(result)")
        }
    }
    
    @IBAction func allowLocationAlways(_ sender: Any) {
        Permission.locationAlways.request { result, error in
            print("\(result)")
        }
    }
    
    @IBAction func allowNotifications(_ sender: Any) {
        Permission.notifications.request { result, error in
            switch result {
            case .allowed where !UIApplication.shared.isRegisteredForRemoteNotifications:
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in
                    DispatchQueue.main.sync {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

@objc enum Permission: Int {
    case camera = 0, photoLibrary, contacts, locationWhenInUse, locationAlways, notifications
    
    var status: PermissionStatus {
        switch self {
        case .camera:
            return Please.shareStatus(for: .camera)
        case .photoLibrary:
            return Please.shareStatus(for: .photoLibrary)
        case .locationWhenInUse:
            return Please.shareStatus(for: .locationWhenInUse)
        case .locationAlways:
            return Please.shareStatus(for: .locationAlways)
        case .contacts:
            return Please.shareStatus(for: .contacts)
        case .notifications:
            return Please.shareStatus(for: .notifications)
        }
    }
    
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
        case .notifications:
            return "Allow Notifications"
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
        case .notifications:
            return "Allow us to send you Notifications to keep you updated."
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
        case .notifications:
            return "Notifications Denied"
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
        case .notifications:
            return "Open settings and allow us to send you Notifications to keep you updated."
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
        view.shouldBlurBackground = false
        view.allowButtonTitle = settings
        view.denyButtonTitle = cancel
        view.title = deniedTitle
        view.description = deniedDescription
        return view
    }
    
    func request(handler: @escaping Please.Reply) {
        let eventListener = PermissioneventListener()
        
        switch self {
        case .camera:
            Please.allow.camera(softAskView: softAskView, deniedView: deniedView, eventListener: eventListener, completion: handler)
        
        case .photoLibrary:
            Please.allow.photoLibrary(softAskView: softAskView, deniedView: deniedView, eventListener: eventListener, completion: handler)
        
        case .locationWhenInUse:
            Please.allow.location.whenInUse(softAskView: softAskView, deniedView: deniedView, eventListener: eventListener, completion: handler)
            
        case .locationAlways:
            Please.allow.location.always(softAskView: softAskView, deniedView: deniedView, eventListener: eventListener, completion: handler)
            
        case .contacts:
            Please.allow.contacts(softAskView: softAskView, deniedView: deniedView, eventListener: eventListener, completion: handler)
            
        case .notifications:
            Please.allow.notifications(softAskView: softAskView, deniedView: deniedView, eventListener: eventListener, completion: handler)
        }
    }
}

class PermissioneventListener: PleaseAllowEventListener {
    func pleaseAllowPermissionManager(_ manager: PermissionManager, didPerformAction action: Please.Action) {
        print(action.rawValue)
    }
}

@objc
class PermissionRequester: NSObject {
    @objc
    static func request(_ permission: Permission, handler: @escaping Please.Reply) {
        permission.request(handler: handler)
    }
}
