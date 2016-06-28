//
//  ViewController.swift
//  FOToast
//
//  Created by Daniel Krofchick on 06/28/2016.
//  Copyright (c) 2016 Daniel Krofchick. All rights reserved.
//

import UIKit
import FOToast

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FOToastManager.sharedInstance.add(FOPlainToast(color: UIColor.redColor()))
        FOToastManager.sharedInstance.add(FOPlainToast(color: UIColor.blueColor()))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

