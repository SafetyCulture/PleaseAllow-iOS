//
//  SoftAskView.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

open class DeniedAlert: SoftAskView { }

open class SoftAskView {
    private var window: UIWindow?
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
        guard self.window == nil else {
            return
        }
        
        let window = UIWindow(frame:UIScreen.main.bounds)
        window.windowLevel = UIWindowLevelAlert
        window.rootViewController = softAskViewController
        self.window = window
        window.makeKeyAndVisible()
        
        softAskViewController.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
            self.softAskViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.softAskViewController.view.transform = .identity
        }, completion: nil)
    }
    
    @objc internal func hide(_ completion: (() -> ())? = nil) {
        guard let window = self.window else {
            return
        }
        window.resignKey()
        self.window = nil
        UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
            self.softAskViewController.view.alpha = 0
        }, completion: { _ in
            completion?()
        })
    }
    
    @objc private func redirectToSettings() {
        hide {
            self.manager?.redirectToSettings()
            if let type = self.manager?.type {
                self.manager?.tracker?.track(.redirectedToSettings(type))
            }
        }
    }
    
    @objc private func cancelRedirect() {
        hide {
            if let type = self.manager?.type {
                self.manager?.tracker?.track(.deniedAlertDismissed(type))
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
