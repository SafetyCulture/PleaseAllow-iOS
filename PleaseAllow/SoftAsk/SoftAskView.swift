//
//  SoftAskView.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

open class DeniedAlert: SoftAskView { }

public enum SoftAskDisplay {
    case modal
    case fullScreen
}


open class SoftAskView {
    private var window: UIWindow?
    private var type: PermissionManagerType?
    private var manager: PermissionManager?
    
    
    internal var softAskViewController: SoftAskViewController!
    public init(_ display: SoftAskDisplay) {
        switch display {
        case .fullScreen:
            softAskViewController = FullScreenSoftAskViewController.loadFromStoryboard()
        case .modal:
            softAskViewController = SoftAskViewController.loadFromStoryboard()
        }
        softAskViewController.loadView()
    }
    
    /// Backgorund Color for the Soft Ask View. Default is White
    open var backgroundColor: UIColor? {
        get {
            return softAskViewController.container.backgroundColor
        }
        set {
            softAskViewController.container.backgroundColor = newValue
        }
    }
    
    /// Title for Soft Ask View.
    open var title: String? {
        get {
            return softAskViewController.titleLabel.text
        }
        set {
            softAskViewController.titleLabel.text = newValue
        }
    }
    
    /// Description for Soft Ask View
    open var description: String? {
        get {
            return softAskViewController.descriptionLabel.text
        }
        set {
            softAskViewController.descriptionLabel.text = newValue
        }
    }
    
    // Image for Soft Ask View.
    open var image: UIImage? {
        get {
            return softAskViewController.imageView.image
        }
        set {
            softAskViewController.imageView.image = newValue
        }
    }
    
    open var imageTint: UIColor! {
        get {
            return softAskViewController.imageView.tintColor
        }
        set {
            softAskViewController.imageView.tintColor = newValue
        }
    }
    
    /// Set corner radius. Default is 0.
    open var cornerRadius: CGFloat {
        get {
            return softAskViewController.container.layer.cornerRadius
        }
        set {
            softAskViewController.container.layer.cornerRadius = newValue
        }
    }
    
    /// Title for Allow button.
    open var allowButtonTitle: String? {
        get {
            return softAskViewController.allowButton.titleLabel?.text
        }
        set {
            softAskViewController.allowButton?.setTitle(newValue, for: .normal)
        }
    }
    
    /// Title for Deny button.
    open var denyButtonTitle: String? {
        get {
            return softAskViewController.denyButton.titleLabel?.text
        }
        set {
            softAskViewController.denyButton?.setTitle(newValue, for: .normal)
        }
    }
    
    /// Background Color for Allow Button. Default is White
    open var allowButtonBackgroundColor: UIColor? {
        get {
            return softAskViewController.allowButton.backgroundColor
        }
        set {
            softAskViewController.allowButton.backgroundColor = newValue
        }
    }
    
    /// Background Color for Deny Button. Default is White
    open var denyButtonBackgroundColor: UIColor? {
        get {
            return softAskViewController.denyButton.backgroundColor
        }
        set {
            softAskViewController.denyButton.backgroundColor = newValue
        }
    }
    
    /// Title Color for Allow Button. Default is system blue
    open var allowButtonTitleColor: UIColor? {
        get {
            return softAskViewController.allowButton.titleLabel?.textColor
        }
        set {
            softAskViewController.allowButton.setTitleColor(newValue, for: .normal)
        }
    }
    
    /// Title Color for Deny Button. Default is system blue
    open var denyButtonTitleColor: UIColor? {
        get {
            return softAskViewController.denyButton.titleLabel?.textColor
        }
        set {
            softAskViewController.denyButton.setTitleColor(newValue, for: .normal)
        }
    }
    
    /// Font for Title Label. Default is UIFont.systemFont(ofSize: 22)
    open var titleLabelFont: UIFont? {
        get {
            return softAskViewController.titleLabel.font
        }
        set {
            softAskViewController.titleLabel.font = newValue
        }
    }
    
    /// Text Color for Title Label. Default is Dark Gray
    open var titleTextColor: UIColor {
        get {
            return softAskViewController.titleLabel.textColor
        }
        set {
            softAskViewController.titleLabel.textColor = newValue
        }
    }
    
    /// Text Color for Description Label. Default is Dark Gray
    open var descriptionTextColor: UIColor {
        get {
            return softAskViewController.descriptionLabel.textColor
        }
        set {
            softAskViewController.descriptionLabel.textColor = newValue
        }
    }
    
    /// Font for Description Label. Default is UIFont.preferredFont(forTextStyle: .body)
    open var descriptionLabelFont: UIFont {
        get {
            return softAskViewController.descriptionLabel.font
        }
        set {
            softAskViewController.descriptionLabel.font = newValue
        }
    }
    
    /// Font for Allow Button. Default is UIFont.preferredFont(forTextStyle: .body)
    open var allowButtonTitleFont: UIFont? {
        get {
            return softAskViewController.allowButton.titleLabel?.font
        }
        set {
            softAskViewController.allowButton.titleLabel?.font = newValue
        }
    }
    
    /// Font for Deny Button. Default is UIFont.preferredFont(forTextStyle: .headline)
    open var denyButtonTitleFont: UIFont? {
        get {
            return softAskViewController.denyButton.titleLabel?.font
        }
        set {
            softAskViewController.denyButton.titleLabel?.font = newValue
        }
    }
    
    private lazy var alertViewController: UIViewController = {
        return UIViewController()
    }()
    
    internal func presentSoftAsk(for manager: PermissionManager) {
        type = manager.type
        guard let requestManager = manager as? RequestManager else { return }
        
        self.manager = manager
        
        softAskViewController.allowButton.removeTarget(nil, action: nil, for: .allEvents)
        softAskViewController.denyButton.removeTarget(nil, action: nil, for: .allEvents)
        
        softAskViewController.allowButton.addTarget(requestManager, action: #selector(requestManager.softPermissionGranted), for: .touchUpInside)
        softAskViewController.denyButton.addTarget(requestManager, action: #selector(requestManager.softPermissionDenied), for: .touchUpInside)
        show()
    }
    
    internal func presentDeniedAlert(for manager: PermissionManager) {
        guard self.window == nil else {
            return
        }
        
        self.manager = manager
        
        softAskViewController.allowButton.removeTarget(nil, action: nil, for: .allEvents)
        softAskViewController.denyButton.removeTarget(nil, action: nil, for: .allEvents)
        
        softAskViewController.denyButton.addTarget(self, action: #selector(cancelRedirect), for: .touchUpInside)
        softAskViewController.allowButton.addTarget(self, action: #selector(redirectToSettings), for: .touchUpInside)
        show()
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
        
        softAskViewController.container.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
            self.softAskViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.softAskViewController.container.transform = .identity
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
            if let type = self.type {
                self.manager?.tracker?.track(.redirectedToSettings(type))
            }
        }
    }
    
    @objc private func cancelRedirect() {
        hide {
            if let type = self.type {
                self.manager?.tracker?.track(.deniedAlertDismissed(type))
            }
        }
    }
}
