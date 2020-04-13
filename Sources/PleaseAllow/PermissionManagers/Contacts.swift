//
//  Contacts.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import UIKit
import Contacts

internal class ContactsManager: PermissionManager {
    
    //MARK:- Type
    
    var type: PermissionManagerType = .contacts
    
    //MARK:- Initializer
    
    internal init(_ status: CNAuthorizationStatus? = nil, _ testing: Bool = false) {
        cnAuthorizationStatus = status ?? CNContactStore.authorizationStatus(for: .contacts)
        self.testing = testing
    }
    
    //MARK:- Result Handler
    
    var resultHandler: Please.Reply?
    
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
        default: return .notDetermined
        }
    }
    
    //MARK:- Soft Ask View
    
    var softAsk: SoftAsk?
    
    //MARK:- Denied Alert
    
    var deniedAlert: DeniedAlert?
    
    //MARK:- Contact Store
    
    var contactStore: CNContactStore?
    
    var eventListener: PleaseAllowEventListener?
}

extension ContactsManager: RequestManager {
    
    @objc func softPermissionGranted() {
        eventListener?.pleaseAllowPermissionManager(self, didPerform: .softAskAllowed)
        softAsk?.hide { [weak self] in
            self?.requestHardPermission()
        }
    }
    
    @objc func softPermissionDenied() {
        eventListener?.pleaseAllowPermissionManager(self, didPerform: .softAskDenied)
        softAsk?.hide { [weak self] in
            guard let handler = self?.resultHandler else { return }
            handler(.softDenial)
        }
    }
    
    func requestHardPermission() {
        guard let handler = resultHandler else { return }
        
        eventListener?.pleaseAllowPermissionManager(self, didPerform: .hardAskPresented)
        
        contactStore = CNContactStore()
        guard let contactStore = self.contactStore else { return }
        
        contactStore.requestAccess(for: .contacts) { granted, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    handler(.hardDenial)
                    return
                }
                
                if granted {
                    self.eventListener?.pleaseAllowPermissionManager(self, didPerform: .hardAskAllowed)
                    self.cnAuthorizationStatus = .authorized
                    handler(.allowed)
                    
                } else {
                    self.eventListener?.pleaseAllowPermissionManager(self, didPerform: .hardAskDenied)
                    self.cnAuthorizationStatus = .denied
                    handler(.hardDenial)
                }
            }
        }
    }
}
