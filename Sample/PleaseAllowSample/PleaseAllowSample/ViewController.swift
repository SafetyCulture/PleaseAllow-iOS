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
        PleaseAllow.Managers.camera.softAskView = PermissionType.camera.softAskView
        PleaseAllow.camera { result, error in
            print(result)
        }
    }
    
    @IBAction func allowPhotoLibrary(_ sender: Any) {
        PleaseAllow.Managers.photoLibrary.softAskView = PermissionType.photoLibrary.softAskView
        PleaseAllow.photoLibrary { result, error in
            print(result)
        }
    }
    @IBAction func allowContacts(_ sender: Any) {
        PleaseAllow.Managers.contacts.softAskView = PermissionType.contacts.softAskView
        PleaseAllow.contacts { result, error in
            print(result)
        }
    }
    @IBAction func allowLocationWhenInUse(_ sender: Any) {
        PleaseAllow.Managers.location.whenInUse.softAskView = PermissionType.locationWhenInUse.softAskView
        PleaseAllow.location.whenInUse { result, error in
            print(result)
        }
    }
    @IBAction func allowLocationAlways(_ sender: Any) {
        PleaseAllow.Managers.location.always.softAskView = PermissionType.locationAlways.softAskView
        PleaseAllow.location.always { result, error in
            print(result)
        }
    }
    @IBAction func allowPushNotification(_ sender: Any) {
        PleaseAllow.Managers.push.softAskView = PermissionType.push.softAskView
        PleaseAllow.push { result, error in
            guard !UIApplication.shared.isRegisteredForRemoteNotifications else { return }
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

enum PermissionType {
    case camera, photoLibrary, contacts, locationWhenInUse, locationAlways, push
    
    var allowTitle: String {
        return "Allow"
    }
    
    var denyTitle: String {
        return "Don't Allow"
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
    
    var softAskView: SoftAskView {
        let view = SoftAskView()
        view.cornerRadius = 20
        view.allowButtonTitle = allowTitle
        view.denyButtonTitle = denyTitle
        view.title = title
        view.description = description
        return view
    }
}
