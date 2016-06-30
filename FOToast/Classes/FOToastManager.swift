//
//  FOToastManager.swift
//  Pods
//
//  Created by Daniel Krofchick on 2016-06-28.
//
//

import Foundation

public class FOToastManager: NSObject {
    
    public static var sharedInstance = FOToastManager()
    
    public var window: UIWindow? = nil
    public var queue = NSOperationQueue()
    var currentToast: FOToast? = nil
    
    override init() {
        super.init()
        
        queue.maxConcurrentOperationCount = 1
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didChangeStatusBarFrame), name: UIApplicationDidChangeStatusBarFrameNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public func add(toast: FOToast) {
        queue.addOperation(FOCompletionOperation(work: {
            [weak self] operation in
            self?.addBackgroundTap(toast)
            self?.show(toast, completion: { finished in
                delay(toast.duration, closure: { 
                    self?.hide(toast, completion: { finished in
                        operation.finish()
                    })
                })
            })
        }, queue: dispatch_get_main_queue()))
    }
    
    func addBackgroundTap(toast: FOToast) {
        toast.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doBackgroundtap)))
    }
    
    func doBackgroundtap() {
        if let currentToast = currentToast {
            currentToast.backgroundTap?()
            hide(currentToast)
        }
    }
    
    func show(toast: FOToast, animated: Bool = true, completion: ((Bool)->())? = nil) {
        if let view = view() {
            currentToast = toast
            view.addSubview(toast.view)
            toast.view.frame = toast.startFrame(view)
            
            UIView.animateWithDuration(animated ? toast.animationTime : 0, animations: {
                toast.view.frame = toast.middleFrame(view)
            }, completion: completion)
        }
    }
    
    func hide(toast: FOToast, animated: Bool = true, completion: ((Bool)->())? = nil) {
        if let view = view() {
            UIView.animateWithDuration(animated ? toast.animationTime : 0, animations: {
                toast.view.frame = toast.endFrame(view)
            }, completion: {
                finished in
                toast.view.removeFromSuperview()
                self.currentToast = nil
                completion?(finished)
            })
        }
    }
    
    func view() -> UIView? {
        if window == nil {
            if let keyWindow = UIApplication.sharedApplication().keyWindow {
                window = TouchForwardingWindow()
                window?.frame = keyWindow.frame
                window?.hidden = false
                window?.windowLevel = UIWindowLevelNormal
                window?.backgroundColor = UIColor.clearColor()
                window?.rootViewController = UIViewController()
            }
        }
        
        return window?.rootViewController?.view
    }
    
    func didChangeStatusBarFrame() {
        if let
            currentToast = currentToast,
            view = view()
        {
            currentToast.view.frame = currentToast.update(view)
        }
    }
    
}

class TouchForwardingWindow: UIWindow {
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        var hitView = super.hitTest(point, withEvent: event)
        
        if hitView == rootViewController?.view {
            hitView = nil
        }
        
        return hitView
    }
    
}

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}
