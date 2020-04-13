//
//  SoftAsk.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import UIKit

public class DeniedAlert: SoftAsk { }
private var sharedWindow: UIWindow?

open class SoftAsk {
    private var manager: PermissionManager?
    
    internal func present(for manager: PermissionManager) {
        self.manager = manager
        show()
    }
    
    private let viewState: ViewState
    public init(
        title: String,
        description: String = "",
        image: UIImage? = nil,
        allowButton: Button = .init(title: "Allow"),
        denyButton: Button = .init(title: "Don't Allow")
    ) {
        viewState = .init(title: title, description: description, image: image, allowButton: allowButton, denyButton: denyButton)
    }
    
    lazy var viewController: SoftAskController = {
        let viewController = SoftAskController()
        viewController.titleLabel.text = viewState.title
        viewController.descriptionLabel.text = viewState.description
        viewController.imageView.image = viewState.image
        viewController.allowButton.setTitle(viewState.allowButton.title, for: .normal)
        viewController.allowButton.titleLabel?.font = viewState.allowButton.font
        viewController.denyButton.setTitle(viewState.denyButton.title, for: .normal)
        viewController.denyButton.titleLabel?.font = viewState.denyButton.font
        viewController.delegate = self
        return viewController
    }()
    
    internal func show() {
        guard sharedWindow == nil else {
            return
        }
        
        let window = UIWindow(frame:UIScreen.main.bounds)
        window.windowLevel = UIWindow.Level.alert
        window.rootViewController = viewController
        sharedWindow = window
        window.makeKeyAndVisible()
        
        viewController.view.alpha = 0
        viewController.container.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseOut, animations: {
            self.viewController.view.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.viewController.container.transform = .identity
        }, completion: nil)
    }
    
    @objc internal func hide(_ completion: (() -> ())? = nil) {
        guard let window = sharedWindow else {
            return
        }
        
        window.resignKey()
        sharedWindow = nil
        
        UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
            self.viewController.view.alpha = 0
        }, completion: { _ in
            completion?()
        })
    }
    
    @objc private func redirectToSettings() {
        hide {
            self.manager?.redirectToSettings()
            if let manager = self.manager {
                manager.eventListener?.pleaseAllowPermissionManager(manager, didPerform: .redirectedToSettings)
            }
        }
    }
    
    @objc private func cancelRedirect() {
        hide {
            if let manager = self.manager {
                manager.eventListener?.pleaseAllowPermissionManager(manager, didPerform: .deniedAlertDismissed)
            }
        }
    }
}

extension SoftAsk: SoftAskControllerDelegate {
    func softAskController(_ viewController: SoftAskController, didPerform action: Action) {
        if self is DeniedAlert {
            action == .allow ? redirectToSettings() : cancelRedirect()
        } else {
            guard let requestManager = self.manager as? RequestManager else { return }
            action == .allow ? requestManager.softPermissionGranted() : requestManager.softPermissionDenied()
        }
    }
}


extension SoftAsk {
    enum Action {
        case allow
        case deny
    }
    
    struct ViewState {
        let title: String
        let description: String
        let image: UIImage?
        let allowButton: Button
        let denyButton: Button
    }
}

public extension SoftAsk {
    public struct Button {
        let title: String
        let font: UIFont
        
        public init(title: String, font: UIFont = .preferredFont(forTextStyle: .body)) {
            self.title = title
            self.font = font
        }
    }
}
