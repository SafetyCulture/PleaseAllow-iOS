//
//  SoftAskView.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import UIKit

open class DeniedAlert: SoftAskView { }

/**
 
    View generator for a soft ask.
 
 */

private var sharedWindow: UIWindow?

open class SoftAskView {
    private var manager: PermissionManager?
    
    internal var softAskViewController: SoftAskViewController!
    
    internal func present(for manager: PermissionManager) {
        self.manager = manager
        show()
    }
    
    public init(_ display: DisplayType) {
        switch display {
        case .fullScreen:
            softAskViewController = FullScreenSoftAskViewController.loadFromStoryboard()
        case .modal:
            softAskViewController = SoftAskViewController.loadFromStoryboard()
        }
        
        softAskViewController.delegate = self
        softAskViewController.loadView()
    }
    
    internal func show() {
        guard sharedWindow == nil else {
            return
        }
        
        let window = UIWindow(frame:UIScreen.main.bounds)
        window.windowLevel = UIWindow.Level.alert
        window.rootViewController = softAskViewController
        sharedWindow = window
        window.makeKeyAndVisible()
        
        softAskViewController.view.alpha = 0
        softAskViewController.container.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseOut, animations: {
            self.softAskViewController.view.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.softAskViewController.container.transform = .identity
        }, completion: nil)
    }
    
    @objc internal func hide(_ completion: (() -> ())? = nil) {
        guard let window = sharedWindow else {
            return
        }
        
        window.resignKey()
        sharedWindow = nil
        
        UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
            self.softAskViewController.view.alpha = 0
        }, completion: { _ in
            completion?()
        })
    }
    
    @objc private func redirectToSettings() {
        hide {
            self.manager?.redirectToSettings()
            if let manager = self.manager {
                manager.eventListener?.pleaseAllowPermissionManager(manager, didPerformAction: .redirectedToSettings)
            }
        }
    }
    
    @objc private func cancelRedirect() {
        hide {
            if let manager = self.manager {
                manager.eventListener?.pleaseAllowPermissionManager(manager, didPerformAction: .deniedAlertDismissed)
            }
        }
    }
}

extension SoftAskView: SoftAskViewControllerDelegate {
    func softAskViewController(_ viewController: SoftAskViewController, didSelectAction action: SoftAskView.Action) {
        if self is DeniedAlert {
            action == .allow ? redirectToSettings() : cancelRedirect()
        } else {
            guard let requestManager = self.manager as? RequestManager else { return }
            action == .allow ? requestManager.softPermissionGranted() : requestManager.softPermissionDenied()
        }
    }
}
