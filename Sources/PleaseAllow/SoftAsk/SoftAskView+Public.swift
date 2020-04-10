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
        get {
            return softAskViewController.titleLabel.text
        }
        set {
            softAskViewController.titleLabel.text = newValue
            softAskViewController.container.layoutIfNeeded()
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
    
    /// Image for Soft Ask View.
    open var image: UIImage? {
        get {
            return softAskViewController.imageView.image
        }
        set {
            softAskViewController.imageView.image = newValue
        }
    }
    
    /// Image tint for Soft Ask Vuew.
    open var imageTint: UIColor! {
        get {
            return softAskViewController.imageView.tintColor
        }
        set {
            softAskViewController.imageView.tintColor = newValue
        }
    }
    
    /// Title for Allow button.
    open var allowButtonTitle: String? {
        get {
            return softAskViewController.allowButton.titleLabel?.text
        }
        set {
            softAskViewController.allowButton.setTitle(newValue, for: .normal)
        }
    }
    
    /// Title for Deny button.
    open var denyButtonTitle: String? {
        get {
            return softAskViewController.denyButton.titleLabel?.text
        }
        set {
            softAskViewController.denyButton.setTitle(newValue, for: .normal)
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
}
