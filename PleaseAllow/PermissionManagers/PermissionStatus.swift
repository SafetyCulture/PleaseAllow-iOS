//
//  PermissionStatus.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import Foundation

/// Common status types for all Permission Managers
public enum PermissionStatus: NSInteger {
    case notDetermined
    case authorized
    case denied
    case restricted
    case unavailable
}

