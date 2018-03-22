//
//  Contacts.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import Foundation
import Contacts

internal class Contacts: PermissionManager {
    
    //MARK:- Type
    
    var type: PermissionManagerType = .contacts
    
    //MARK:- Initializer
    
    internal init(_ status: CNAuthorizationStatus? = nil, _ testing: Bool = false) {
        cnAuthorizationStatus = status ?? CNContactStore.authorizationStatus(for: .contacts)
        self.testing = testing
    }
    
    //MARK:- Result Handler
    
    var resultHandler: PleaseAllowReply?
    
    //MARK:- Availability
    
    var isAvailable: Bool = true
    
    //MARK:- Testing
    
    private var testing: Bool = false
    
    //MARK:- Status
    
    fileprivate var cnAuthorizationStatus: CNAuthorizationStatus
    
    var status: PermissionStatus {
        let status = testing ? cnAuthorizationStatus : CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .authorized:    return .authorized
        case .denied:        return .denied
        case .restricted:    return .restricted
        case .notDetermined: return .notDetermined
        }
    }
    
    //MARK:- Soft Ask View
    
    var softAskView: SoftAskView?
    
    //MARK:- Denied Alert
    
    var deniedAlert: DeniedAlert?
    
    //MARK:- Contact Store
    
    var contactStore: CNContactStore?
    
    var tracker: PleaseAllowTracker?
}

extension Contacts: RequestManager {
    
    @objc func softPermissionGranted() {
        tracker?.track(.softAskAllowed(type))
        softAskView?.hide { [weak self] in
            self?.requestHardPermission()
        }
    }
    
    @objc func softPermissionDenied() {
        tracker?.track(.softAskDenied(type))
        softAskView?.hide { [weak self] in
            guard let handler = self?.resultHandler else { return }
            handler(.softDenial, nil)
        }
    }
    
    func requestHardPermission() {
        guard let handler = resultHandler else { return }
        
        tracker?.track(.hardAskPresented(type))
        
        contactStore = CNContactStore()
        guard let contactStore = self.contactStore else { return }
        
        contactStore.requestAccess(for: .contacts) { granted, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.tracker?.track(.error(self.type, error))
                    handler(.hardDenial, error)
                    return
                }
                
                if granted {
                    self.tracker?.track(.hardAskAllowed(self.type))
                    self.cnAuthorizationStatus = .authorized
                    handler(.allowed, nil)
                    
                } else {
                    self.tracker?.track(.hardAskDenied(self.type))
                    self.cnAuthorizationStatus = .denied
                    handler(.hardDenial, nil)
                }
            }
        }
    }
}
