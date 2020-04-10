//
//  SoftAskView+Public.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 9/4/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import UIKit

extension SoftAskView {
    
    public enum DisplayType {
        case modal
        case fullScreen
    }
    
    internal enum Action {
        case allow
        case deny
    }
    
    /// Title for Soft Ask View.
    open var title: String? {
        get { return viewController.titleLabel.text }
        set { viewController.titleLabel.text = newValue }
    }
    
    /// Description for Soft Ask View
    open var description: String? {
        get { return viewController.descriptionLabel.text }
        set { viewController.descriptionLabel.text = newValue }
    }
    
    /// Image for Soft Ask View.
    open var image: UIImage? {
        get { return viewController.imageView.image }
        set { viewController.imageView.image = newValue }
    }
    
    /// Image tint for Soft Ask Vuew.
    open var imageTint: UIColor! {
        get { return viewController.imageView.tintColor }
        set { viewController.imageView.tintColor = newValue }
    }
    
    /// Title for Allow button.
    open var allowButtonTitle: String? {
        get { return viewController.allowButton.titleLabel?.text }
        set { viewController.allowButton.setTitle(newValue, for: .normal) }
    }
    
    /// Title for Deny button.
    open var denyButtonTitle: String? {
        get { return viewController.denyButton.titleLabel?.text }
        set { viewController.denyButton.setTitle(newValue, for: .normal) }
    }
    
    /// Font for Title Label. Default is UIFont.systemFont(ofSize: 22)
    open var titleLabelFont: UIFont? {
        get { return viewController.titleLabel.font }
        set { viewController.titleLabel.font = newValue }
    }
    
    /// Font for Description Label. Default is UIFont.preferredFont(forTextStyle: .body)
    open var descriptionLabelFont: UIFont {
        get { return viewController.descriptionLabel.font }
        set { viewController.descriptionLabel.font = newValue }
    }
    
    /// Font for Allow Button. Default is UIFont.preferredFont(forTextStyle: .body)
    open var allowButtonTitleFont: UIFont? {
        get { return viewController.allowButton.titleLabel?.font }
        set { viewController.allowButton.titleLabel?.font = newValue }
    }
    
    /// Font for Deny Button. Default is UIFont.preferredFont(forTextStyle: .headline)
    open var denyButtonTitleFont: UIFont? {
        get { return viewController.denyButton.titleLabel?.font }
        set { viewController.denyButton.titleLabel?.font = newValue }
    }
}
