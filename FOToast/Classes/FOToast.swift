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
    var duration: TimeInterval {get set}
    var animationTime: TimeInterval {get set}
    var backgroundTap: (()->())? {get set}
    weak var toastManager: FOToastManager? {get set}
    func identifier() -> String?
    func hasContent() -> Bool
    
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
        return UIRectEdge.bottom
    }
    
    func startFrame(_ superview: UIView) -> CGRect {
        let size = view.sizeThatFits(superview.frame.size)
        var y = CGFloat(0)
        
        if edge() == .top {
            y = -size.height
        } else if edge() == .bottom {
            y = superview.frame.height
        }
        
        return CGRect(x: (superview.frame.width - size.width) / 2.0, y: y, width: size.width, height: size.height)
    }
    
    func middleFrame(_ superview: UIView) -> CGRect {
        let size = view.sizeThatFits(superview.frame.size)
        var y = CGFloat(0)
        
        if edge() == .top {
            y = 0
        } else if edge() == .bottom {
            y = superview.frame.height - size.height
        }
        
        return CGRect(x: (superview.frame.width - size.width) / 2.0, y: y, width: size.width, height: size.height)
    }
    
    func endFrame(_ superview: UIView) -> CGRect {
        return startFrame(superview)
    }
    
    // Updates frame on rotation
    func update(_ superview: UIView) -> CGRect {
        let size = view.sizeThatFits(superview.frame.size)
        
        return CGRect(x: (superview.frame.width - size.width) / 2.0, y: view.frame.origin.y, width: size.width, height: view.frame.height)
    }
    
}

open class FOPlainToast: NSObject, FOToast {
    
    open var view = UIView()
    open var duration = 3.0
    open var animationTime = 3.0
    open var backgroundTap: (() -> ())? = nil
    open var toastManager: FOToastManager? = nil
    
    public init(color: UIColor) {
        view = FOPlainView()
        view.backgroundColor = color
        view.layer.borderColor = UIColor.yellow.cgColor
        view.layer.borderWidth = 2
    }
    
    open func identifier() -> String? {
        return nil
    }
    
    open func hasContent() -> Bool {
        return true
    }
    
}

open class FOPlainView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 100)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
