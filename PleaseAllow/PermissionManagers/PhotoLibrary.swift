//
//  PhotoLibrary.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import Foundation
import Photos

internal class PhotoLibrary: PermissionManager {
    
    //MARK:- Type
    
    var type: PermissionManagerType = .photoLibrary
    
    //MARK:- Initializer
    
    internal init(_ status: PHAuthorizationStatus? = nil, _ testing: Bool = false) {
        phAuthorizationStatus = status ?? PHPhotoLibrary.authorizationStatus()
        self.testing = testing
    }
    
    //MARK:- Result Handler
    
    var resultHandler: Please.Reply?
    
    //MARK:- Availability
    
    var isAvailable: Bool {
        guard let handler = resultHandler else { return false }
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            handler(.unavailable, nil)
            return false
        }
        return true
    }
    
    //MARK:- Testing
    
    private var testing: Bool = false
    
    //MARK:- Status
    
    fileprivate var phAuthorizationStatus: PHAuthorizationStatus
    
    var status: PermissionStatus {
        let status = testing ? phAuthorizationStatus : PHPhotoLibrary.authorizationStatus()
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
    
    var tracker: PleaseAllowTracker?
}

extension PhotoLibrary: RequestManager {
    
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
        
        PHPhotoLibrary.requestAuthorization { status in
            self.phAuthorizationStatus = status
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.tracker?.track(.hardAskAllowed(self.type))
                    handler(.allowed, nil)
                case .denied:
                    self.tracker?.track(.hardAskDenied(self.type))
                    handler(.hardDenial, nil)
                default:
                    break;
                }
            }
        }
    }
}
