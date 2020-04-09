//
//  Notifications.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import UIKit

internal class Notifications: PermissionManager {
    
    //MARK:- Type
    
    var type: PermissionManagerType = .notifications
    
    //MARK:- Initializer
    
    internal init(_ status: Bool? = false, _ testing: Bool = false) {
        remoteNotificationsStatus = status ?? UIApplication.shared.isRegisteredForRemoteNotifications
        self.testing = testing
    }
    
    //MARK:- Result Handler
    
    var resultHandler: Please.Reply?
    
    //MARK:- Availability
    
    var isAvailable = true
    
    //MARK:- Testing
    
    private var testing: Bool = false
    
    //MARK:- Status
    
    fileprivate var remoteNotificationsStatus: Bool
    
    var status: PermissionStatus {
        let authorized: Bool = UIApplication.shared.isRegisteredForRemoteNotifications
        let status = testing ? remoteNotificationsStatus : authorized
        
        switch status {
        case true:
            return .authorized
        default  :
            return .notDetermined
        }
    }
    
    //MARK:- Soft Ask View
    
    var softAskView: SoftAskView?
    
    //MARK:- Denied Alert
    
    var deniedAlert: DeniedAlert?
    
    var eventListener: PleaseAllowEventListener?
}

extension Notifications: RequestManager {
    
    @objc func softPermissionGranted() {
        eventListener?.pleaseAllowPermissionManager(self, didPerformAction: .softAskAllowed)
        softAskView?.hide { [weak self] in
            self?.resultHandler?(.allowed, nil)
        }
    }
    
    @objc func softPermissionDenied() {
        eventListener?.pleaseAllowPermissionManager(self, didPerformAction: .softAskDenied)
        softAskView?.hide { [weak self] in
            guard let handler = self?.resultHandler else { return }
            handler(.softDenial, nil)
        }
    }
    
    func requestHardPermission() {}
}

