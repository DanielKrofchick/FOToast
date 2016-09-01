//
//  FOToast.swift
//  Pods
//
//  Created by Daniel Krofchick on 2016-06-28.
//
//

import Foundation

@objc public protocol FOToast {
    
    var view: UIView {get set}
    var duration: NSTimeInterval {get set}
    var animationTime: NSTimeInterval {get set}
    var backgroundTap: (()->())? {get set}
    weak var toastManager: FOToastManager? {get set}
    
}

public extension FOToast {
    
    // Toast not shown if matches current toast
    func identifier() -> String? {
        return nil
    }
    
    // If false, toast is not shown
    func hasContent() -> Bool {
        return true
    }
    
    func edge() -> UIRectEdge {
        return UIRectEdge.Bottom
    }
    
    func startFrame(superview: UIView) -> CGRect {
        let size = view.sizeThatFits(superview.frame.size)
        var y = CGFloat(0)
        
        if edge() == .Top {
            y = -size.height
        } else if edge() == .Bottom {
            y = superview.frame.height
        }
        
        return CGRect(x: (superview.frame.width - size.width) / 2.0, y: y, width: size.width, height: size.height)
    }
    
    func middleFrame(superview: UIView) -> CGRect {
        let size = view.sizeThatFits(superview.frame.size)
        var y = CGFloat(0)
        
        if edge() == .Top {
            y = 0
        } else if edge() == .Bottom {
            y = superview.frame.height - size.height
        }
        
        return CGRect(x: (superview.frame.width - size.width) / 2.0, y: y, width: size.width, height: size.height)
    }
    
    func endFrame(superview: UIView) -> CGRect {
        return startFrame(superview)
    }
    
    // Updates frame on rotation
    func update(superview: UIView) -> CGRect {
        let size = view.sizeThatFits(superview.frame.size)
        
        return CGRect(x: (superview.frame.width - size.width) / 2.0, y: view.frame.origin.y, width: size.width, height: view.frame.height)
    }
    
}

public class FOPlainToast: NSObject, FOToast {
    
    public var view = UIView()
    public var duration = 3.0
    public var animationTime = 3.0
    public var backgroundTap: (() -> ())? = nil
    public var toastManager: FOToastManager? = nil
    
    public init(color: UIColor) {
        view = FOPlainView()
        view.backgroundColor = color
        view.layer.borderColor = UIColor.yellowColor().CGColor
        view.layer.borderWidth = 2
    }
    
}

public class FOPlainView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 100)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}