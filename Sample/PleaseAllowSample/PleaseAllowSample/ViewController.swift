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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PleaseAllow.camera { result, error in
            print(result)
        }
    }
}

