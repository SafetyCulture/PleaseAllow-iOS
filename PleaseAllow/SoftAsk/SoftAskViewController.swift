//
//  SoftAskViewController.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import UIKit

internal class SoftAskViewController: UIViewController {
    
    static func loadFromStoryboard() -> SoftAskViewController {
        let storyboard = UIStoryboard(name: "SoftAsk", bundle: Bundle(for: SoftAskViewController.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "SoftAskViewController")
        return viewController as! SoftAskViewController
    }
    
    @IBOutlet var container: UIView! {
        didSet {
            container.backgroundColor = .white
            container.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .darkGray
            titleLabel.textAlignment = .center
        }
    }
    
    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 0
            descriptionLabel.lineBreakMode = .byWordWrapping
        }
    }
    
    @IBOutlet var buttonsContainer: UIView!
    
    @IBOutlet var allowButton: UIButton! {
        didSet {
            allowButton.backgroundColor = .white
        }
    }
    
    @IBOutlet var denyButton: UIButton! {
        didSet {
            denyButton.backgroundColor = .white
        }
    }
    
    func layout() {
        
        if traitCollection.userInterfaceIdiom == .phone && (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight) {
            
            titleLabel.textAlignment = .left
            descriptionLabel.textAlignment = .left
            
        } else {
            titleLabel.textAlignment = .center
            descriptionLabel.textAlignment = .center
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        layout()
    }
    
    func setup() {
        layout()
    }
}
