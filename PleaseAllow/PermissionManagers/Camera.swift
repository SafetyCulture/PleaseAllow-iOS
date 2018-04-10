//
//  Camera.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import Foundation
import AVFoundation

internal class Camera: PermissionManager {
    
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
            handler(.unavailable, nil)
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
        case .notDetermined : return .notDetermined
        }
    }
    
    //MARK:- Soft Ask View
    
    var softAskView: SoftAskView?
    
    //MARK:- Denied Alert
    
    var deniedAlert: DeniedAlert?
    
    var tracker: PleaseAllowTracker?
}

extension Camera: RequestManager {
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
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.tracker?.track(.hardAskAllowed(self.type))
                    self.avAuthorizationStatus = .authorized
                    handler(.allowed, nil)
                    
                } else {
                    self.tracker?.track(.hardAskDenied(self.type))
                    self.avAuthorizationStatus = .denied
                    handler(.hardDenial, nil)
                }
            }
        }
    }
}
