//
//  Notifications.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import UIKit
import UserNotifications

internal class NotificationsManager: PermissionManager {
    
    //MARK:- Type
    
    var type: PermissionManagerType = .notifications
    
    //MARK:- Initializer
    
    internal init(_ status: UNAuthorizationStatus? = nil, _ testing: Bool = false) {
        remoteNotificationsStatus = status ?? UNUserNotificationCenter.current().authorizationStatus
        self.testing = testing
    }
    
    //MARK:- Result Handler
    
    var resultHandler: Please.Reply?
    
    //MARK:- Availability
    
    var isAvailable = true
    
    //MARK:- Testing
    
    private var testing: Bool = false
    
    //MARK:- Status
    
    fileprivate var remoteNotificationsStatus: UNAuthorizationStatus
    
    var status: PermissionStatus {
        switch remoteNotificationsStatus {
        case .authorized, .provisional:
            return .authorized
        case .denied:
            return .denied
        default:
            return .notDetermined
        }
    }
    
    //MARK:- Soft Ask View
    
    var softAsk: SoftAsk?
    
    //MARK:- Denied Alert
    
    var deniedAlert: DeniedAlert?
     
    var requestOptions: UNAuthorizationOptions = [.alert, .sound]
    
    var eventListener: PleaseAllowEventListener?
}

extension NotificationsManager: RequestManager {
    
    @objc func softPermissionGranted() {
        eventListener?.pleaseAllowPermissionManager(self, didPerform: .softAskAllowed)
        softAsk?.hide { [weak self] in
            self?.requestHardPermission()
        }
    }
    
    @objc func softPermissionDenied() {
        eventListener?.pleaseAllowPermissionManager(self, didPerform: .softAskDenied)
        softAsk?.hide { [weak self] in
            self?.resultHandler?(.softDenial)
        }
    }
    
    func requestHardPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: requestOptions) { authorized, error in
            DispatchQueue.main.async {
                if authorized {
                    self.eventListener?.pleaseAllowPermissionManager(self, didPerform: .hardAskAllowed)
                    self.remoteNotificationsStatus = .authorized
                    self.resultHandler?(.allowed)
                    
                } else {
                    self.eventListener?.pleaseAllowPermissionManager(self, didPerform: .hardAskDenied)
                    self.remoteNotificationsStatus = .denied
                    self.resultHandler?(.hardDenial)
                }
            }
        }
    }
}

extension UNUserNotificationCenter {
    var authorizationStatus: UNAuthorizationStatus {
        var status: UNAuthorizationStatus = .notDetermined
        let semaphore = DispatchSemaphore(value: 0)
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            status = settings.authorizationStatus
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .distantFuture)
        return status
    }
}
