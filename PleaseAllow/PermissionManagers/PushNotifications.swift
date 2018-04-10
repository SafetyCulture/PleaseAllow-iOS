//
//  PushNotifications.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import Foundation

internal class PushNotifications: PermissionManager {
    
    //MARK:- Type
    
    var type: PermissionManagerType = .pushNotifications
    
    //MARK:- Initializer
    
    internal init(_ status: Bool? = false, _ testing: Bool = false) {
        remoteNotificationsStatus = status ?? UIApplication.shared.isRegisteredForRemoteNotifications
        self.testing = testing
    }
    
    //MARK:- Result Handler
    
    var resultHandler: Please.Reply?
    
    //MARK:- Availability
    
    var isAvailable = true
    
    var canRequest: Bool {
        return status == .notDetermined
    }
    
    //MARK:- Testing
    
    private var testing: Bool = false
    
    //MARK:- Status
    
    fileprivate var remoteNotificationsStatus: Bool
    
    var status: PermissionStatus {
        let status = testing ? remoteNotificationsStatus : UIApplication.shared.isRegisteredForRemoteNotifications
        switch status {
        case true: return .authorized
        default  : return .notDetermined
        }
    }
    
    //MARK:- Soft Ask View
    
    var softAskView: SoftAskView?
    
    //MARK:- Denied Alert
    
    var deniedAlert: DeniedAlert?
    
    var tracker: PleaseAllowTracker?
}

extension PushNotifications: RequestManager {
    
    @objc func softPermissionGranted() {
        softAskView?.hide { [weak self] in
            self?.resultHandler?(.allowed, nil)
        }
    }
    
    @objc func softPermissionDenied() {
        softAskView?.hide { [weak self] in
            guard let handler = self?.resultHandler else { return }
            handler(.softDenial, nil)
        }
    }
    
    func requestHardPermission() {}
}

