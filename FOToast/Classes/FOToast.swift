//
//  FOToast.swift
//  Pods
//
//  Created by Daniel Krofchick on 2016-06-28.
//
//

import Foundation

public protocol FOToast {
    
    var view: UIView {get set}
    var duration: NSTimeInterval {get set}
    var animationTime: NSTimeInterval {get set}
    
}

public extension FOToast {
    
    func startFrame(superview: UIView) -> CGRect {
        let size = view.sizeThatFits(superview.frame.size)
        
        return CGRect(x: (superview.frame.width - size.width) / 2.0, y: -size.height, width: size.width, height: size.height)
    }
    
    func middleFrame(superview: UIView) -> CGRect {
        let size = view.sizeThatFits(superview.frame.size)
        
        return CGRect(x: (superview.frame.width - size.width) / 2.0, y: 0, width: size.width, height: size.height)
    }
    
    func endFrame(superview: UIView) -> CGRect {
        return startFrame(superview)
    }
    
}

public struct FOPlainToast: FOToast {
    
    public var view = UIView()
    public var duration = 1.0
    public var animationTime = 1.0
    
    public init(color: UIColor) {
        view = FOPlainView()
        view.backgroundColor = color
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