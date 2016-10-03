//
//  ViewController.swift
//  FOToast
//
//  Created by Daniel Krofchick on 06/28/2016.
//  Copyright (c) 2016 Daniel Krofchick. All rights reserved.
//

//import UIKit
import FOToast

class ViewController: UIViewController {
    
    let button = UIButton(type: .system)
    var nextColor = UIColor.red

    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.backgroundColor = nextColor
        button.setTitle("Toast", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        view.addSubview(button)
        
        view.addConstraint(NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    func buttonTap() {
        FOToastManager.sharedInstance.add(FOPlainToast(color: nextColor))
        nextColor = UIColor.random(alpha: 1)
        button.backgroundColor = nextColor
    }

}

extension UIColor {
    
    class func random(
        _ red: CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
        green: CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
        blue: CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
        alpha: CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        ) -> UIColor {
        return UIColor(
            red: red,
            green: green,
            blue: blue,
            alpha: alpha
        )
    }
    
}
