//
//  Camera.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import UIKit
import AVFoundation

internal class CameraManager: PermissionManager {
    
    //MARK:- Type
    
    var type: PermissionManagerType = .camera
    
    //MARK:- Initializer
    
    internal init(_ status: AVAuthorizationStatus? = nil, _ testing: Bool = false) {
        avAuthorizationStatus = status ?? AVCaptureDevice.authorizationStatus(for: .video)
        self.testing = testing
    }
    
    //MARK:- Result Handler
    
    var resultHandler: Please.Reply?
    
    //MARK:- Availability
    
    var isAvailable: Bool {
        guard let handler = resultHandler else { return false }
        guard UIImagePickerController.isSourceTypeAvailable(.camera) || testing else {
            handler(.unavailable)
            return false
        }
        return true
    }
    
    //MARK:- Testing
    
    private var testing: Bool = false
    
    //MARK:- Status
    
    fileprivate var avAuthorizationStatus: AVAuthorizationStatus
    
    var status: PermissionStatus {
        let status = testing ? avAuthorizationStatus : AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized    : return .authorized
        case .denied        : return .denied
        case .restricted    : return .restricted
        default: return .notDetermined
        }
    }
    
    //MARK:- Soft Ask View
    
    var softAsk: SoftAsk?
    
    //MARK:- Denied Alert
    
    var deniedAlert: DeniedAlert?
    
    var eventListener: PleaseAllowEventListener?
}

extension CameraManager: RequestManager {
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
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.eventListener?.pleaseAllowPermissionManager(self, didPerform: .hardAskAllowed)
                    self.avAuthorizationStatus = .authorized
                    handler(.allowed)
                    
                } else {
                    self.eventListener?.pleaseAllowPermissionManager(self, didPerform: .hardAskDenied)
                    self.avAuthorizationStatus = .denied
                    handler(.hardDenial)
                }
            }
        }
    }
}
