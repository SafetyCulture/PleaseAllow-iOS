//
//  Location.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import Foundation
import CoreLocation

@objc public enum LocationRequestType: Int {
    case always
    case whenInUse
}

internal class LocationManager: NSObject, PermissionManager {
    
    //MARK:- Type
    
    var type: PermissionManagerType = .location(.whenInUse)
    
    //MARK:- Initializer
    
    internal init(_ status: CLAuthorizationStatus? = nil, _ testing: Bool = false) {
        clAuthorizationStatus = status ?? CLLocationManager.authorizationStatus()
        self.testing = testing
    }
    
    internal override init() {
        testing = false
        clAuthorizationStatus = CLLocationManager.authorizationStatus()
        super.init()
    }
    
    //MARK:- Result Handler
    
    var resultHandler: Please.Reply?
    
    //MARK:- Availability
    
    var isAvailable: Bool {
        guard let handler = resultHandler else { return false }
        guard CLLocationManager.locationServicesEnabled() else {
            handler(.unavailable)
            return false
        }
        return true
    }
    
    //MARK:- Testing
    
    private var testing: Bool = false
    
    //MARK:- Status
    
    fileprivate var clAuthorizationStatus: CLAuthorizationStatus
    
    
    var status: PermissionStatus {
        let status = testing ? clAuthorizationStatus : CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse: return locationType == .always ? .notDetermined : .authorized
        case .authorizedAlways:    return .authorized
        case .denied:              return .denied
        case .restricted:          return .restricted
        default: return .notDetermined
        }
    }
    
    //MARK:- Soft Ask View
    
    var softAsk: SoftAsk?
    
    //MARK:- Denied Alert
    
    var deniedAlert: DeniedAlert?
    
    //MARK:- Location Type
    
    internal var locationType: LocationRequestType = .whenInUse
    
    
    //MARK:- Location Manager
    
    internal var manager: CLLocationManager?
    
    var eventListener: PleaseAllowEventListener?
}

extension LocationManager: RequestManager {
    
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
        manager = CLLocationManager()
        manager?.delegate = self
        guard let manager = self.manager else { return }
        
        eventListener?.pleaseAllowPermissionManager(self, didPerform: .hardAskPresented)
        
        switch locationType {
        case .always:
            manager.requestAlwaysAuthorization()
        case .whenInUse:
            manager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        clAuthorizationStatus = status
        guard let handler = resultHandler else { return }
        switch status {
        case .authorizedAlways:
            handler(.allowed)
            
        case .authorizedWhenInUse:
            if locationType == .whenInUse {
                eventListener?.pleaseAllowPermissionManager(self, didPerform: .hardAskAllowed)
                handler(.allowed)
            } else {
                eventListener?.pleaseAllowPermissionManager(self, didPerform: .hardAskDenied)
                handler(.hardDenial)
            }
            
        case .denied:
            eventListener?.pleaseAllowPermissionManager(self, didPerform: .hardAskDenied)
            handler(.hardDenial)
        default:
            break;
        }
    }
}
