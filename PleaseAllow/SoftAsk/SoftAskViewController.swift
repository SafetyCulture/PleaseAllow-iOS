//
//  SoftAskViewController.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import UIKit

internal protocol StoryboardLoading: class {
    static var identifier: String { get }
}

extension StoryboardLoading {
    static func loadFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: "SoftAsk", bundle: Bundle(for: Self.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return viewController as! Self
    }
}

internal protocol SoftAskViewControllerDelegate: class {
    func softAskViewController(_ viewController: SoftAskViewController, didSelectAction action: SoftAskView.Action)
}

internal class SoftAskViewController: UIViewController, StoryboardLoading {
    
    class var identifier: String {
        return "SoftAskViewController"
    }
    
    weak var delegate: SoftAskViewControllerDelegate?
    
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
    
    @IBAction func denyTapped(_ sender: UIButton) {
        delegate?.softAskViewController(self, didSelectAction: .deny)
    }
    
    @IBAction func allowTapped(_ sender: UIButton) {
        delegate?.softAskViewController(self, didSelectAction: .allow)
    }
}

internal class FullScreenSoftAskViewController: SoftAskViewController {
    override class var identifier: String {
        return "FullScreenSoftAskViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Full screen did load")
        allowButton.layer.cornerRadius = 5
        allowButton.layer.masksToBounds = true
    }
}
