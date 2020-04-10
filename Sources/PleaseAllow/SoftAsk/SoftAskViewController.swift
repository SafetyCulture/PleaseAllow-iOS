//
//  SoftAskViewController.swift
//  PleaseAllow
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

extension UIColor {
    static let primaryBackground: UIColor = {
        if #available(iOS 13.0, *) {
            return .secondarySystemBackground
        } else {
            return .white
        }
    }()
    
    static let secondaryBackground: UIColor = {
        if #available(iOS 13.0, *) {
            return .secondarySystemFill
        } else {
            return .lightGray
        }
    }()
    
    static let primaryText: UIColor = {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .darkGray
        }
    }()
    
    static let secondaryText: UIColor = {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        } else {
            return .gray
        }
    }()
    
    static let linkColor: UIColor = {
        if #available(iOS 13.0, *) {
            return .link
        } else {
            return UIColor.systemBlue
        }
    }()
}

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

internal class SoftAskViewController: UIViewController
{
    weak var delegate: SoftAskViewControllerDelegate?
    
    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(frame: .zero)
        view.effect = {
            if #available(iOS 13.0, *) {
                return UIBlurEffect(style: .systemMaterial)
            } else {
                return UIBlurEffect(style: .light)
            }
        }()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let container: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primaryBackground
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .primaryText
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
     
    let buttonsContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondaryBackground
        return view
    }()
    
    lazy var allowButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .primaryBackground
        button.addTarget(self, action: #selector(allowTapped(_:)), for: .touchUpInside)
        button.setTitleColor(.linkColor, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        return button
    }()
    
    lazy var denyButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .primaryBackground
        button.addTarget(self, action: #selector(denyTapped(_:)), for: .touchUpInside)
        button.setTitleColor(.linkColor, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.addSubview(blurView)
        view.addSubview(container)
        container.addSubview(imageView)
        container.addSubview(titleLabel)
        container.addSubview(descriptionLabel)
        container.addSubview(buttonsContainer)
        
        buttonsContainer.addSubview(allowButton)
        buttonsContainer.addSubview(denyButton)
        
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            container.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
            container.widthAnchor.constraint(lessThanOrEqualToConstant: 320),
            
            imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 48),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            
            buttonsContainer.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            buttonsContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            buttonsContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            buttonsContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            buttonsContainer.heightAnchor.constraint(equalToConstant: 44),
            
            denyButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor, constant: 1),
            denyButton.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor),
            denyButton.bottomAnchor.constraint(equalTo: buttonsContainer.bottomAnchor),
            
            allowButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor, constant: 1),
            allowButton.leadingAnchor.constraint(equalTo: denyButton.trailingAnchor, constant: 1),
            allowButton.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor),
            allowButton.bottomAnchor.constraint(equalTo: buttonsContainer.bottomAnchor),
            allowButton.widthAnchor.constraint(equalTo: denyButton.widthAnchor, multiplier: 1)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc
    private func denyTapped(_ sender: UIButton) {
        delegate?.softAskViewController(self, didSelectAction: .deny)
    }
    
    @objc
    private func allowTapped(_ sender: UIButton) {
        delegate?.softAskViewController(self, didSelectAction: .allow)
    }
    
    internal func toggleBlurView(shouldBlur: Bool) {
        switch shouldBlur {
        case true:
            blurView.alpha = 1
            view.alpha = 0
            
        case false:
            blurView.alpha = 0
            view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }
    }
}

internal class FullScreenSoftAskViewController: SoftAskViewController, StoryboardLoading {
    class var identifier: String {
        return "FullScreenSoftAskViewController"
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        allowButton.layer.cornerRadius = 5
//        allowButton.layer.masksToBounds = true
//
//        denyButton.layer.cornerRadius = 5
//        denyButton.layer.masksToBounds = true
//    }
}
