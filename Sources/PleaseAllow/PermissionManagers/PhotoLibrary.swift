//
//  PhotoLibrary.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import UIKit
import Photos

internal class PhotoLibraryManager: PermissionManager {
    
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
        default: return .notDetermined
        }
    }
    
    //MARK:- Soft Ask View
    
    var softAskView: SoftAskView?
    
    //MARK:- Denied Alert
    var deniedAlert: DeniedAlert?
    
    var eventListener: PleaseAllowEventListener?
}

extension PhotoLibraryManager: RequestManager {
    
    @objc func softPermissionGranted() {
        eventListener?.pleaseAllowPermissionManager(self, didPerformAction: .softAskAllowed)
        softAskView?.hide { [weak self] in
            self?.requestHardPermission()
        }
    }
    
    @objc func softPermissionDenied() {
        eventListener?.pleaseAllowPermissionManager(self, didPerformAction: .softAskDenied)
        softAskView?.hide { [weak self] in
            guard let handler = self?.resultHandler else { return }
            handler(.softDenial, nil)
        }
    }
    
    func requestHardPermission() {
        guard let handler = resultHandler else { return }
        
        eventListener?.pleaseAllowPermissionManager(self, didPerformAction: .hardAskPresented)
        
        PHPhotoLibrary.requestAuthorization { status in
            self.phAuthorizationStatus = status
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.eventListener?.pleaseAllowPermissionManager(self, didPerformAction: .hardAskAllowed)
                    handler(.allowed, nil)
                case .denied:
                    self.eventListener?.pleaseAllowPermissionManager(self, didPerformAction: .hardAskDenied)
                    handler(.hardDenial, nil)
                default:
                    break;
                }
            }
        }
    }
}
