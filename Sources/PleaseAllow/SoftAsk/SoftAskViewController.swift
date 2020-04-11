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
            return .systemBackground
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
            return .black
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

internal protocol SoftAskViewControllerDelegate: class {
    func softAskViewController(_ viewController: SoftAskViewController, didPerform action: SoftAskView.Action)
}

internal class SoftAskViewController: UIViewController {
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
    
    let container: RoundShadowView = {
        let view = RoundShadowView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primaryBackground
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
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .primaryText
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
     
    let buttonsContainer: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .secondaryBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let allowButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .primaryBackground
        button.addTarget(self, action: #selector(allowTapped(_:)), for: .touchUpInside)
        button.setTitleColor(.linkColor, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        return button
    }()
    
    let denyButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .primaryBackground
        button.addTarget(self, action: #selector(denyTapped(_:)), for: .touchUpInside)
        button.setTitleColor(.linkColor, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurView)
        view.addSubview(container)
        container.addSubviews(imageView, titleLabel, descriptionLabel, buttonsContainer)
        
        buttonsContainer.addSubview(allowButton)
        buttonsContainer.addSubview(denyButton)
        
        let containerLeading = container.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24)
        let containerTrailing =  container.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24)
        containerLeading.priority = .defaultHigh
        containerTrailing.priority = .defaultHigh

        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
            containerLeading,
            containerTrailing,
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
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
            buttonsContainer.heightAnchor.constraint(equalToConstant: 54),
            
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
    
    @IBAction func denyTapped(_ sender: UIButton) {
        delegate?.softAskViewController(self, didPerform: .deny)
    }
    
    @IBAction func allowTapped(_ sender: UIButton) {
        delegate?.softAskViewController(self, didPerform: .allow)
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

class RoundShadowView: UIView {
    private lazy var container: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(container)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var backgroundColor: UIColor? {
        get { return container.backgroundColor }
        set { container.backgroundColor = newValue }
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach(container.addSubview)
    }
    
    private let cornerRadius: CGFloat = 16.0

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 8
    }
}
