//
//  ViewController.swift
//  PleaseAllowSample
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import UIKit
import PleaseAllow

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PleaseAllow.Managers.photoLibrary.softAskView = {
            let view = SoftAskView()
            view.cornerRadius = 20
            view.allowButtonTitle = "Allow"
            view.denyButtonTitle = "Don't Allow"
            view.title = "Allow Photo Library"
            view.description = "Allow access to your Photo Library in order to add images to your work."
            return view
        }()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PleaseAllow.photoLibrary { result, error in
            print(result)
        }
    }
}
