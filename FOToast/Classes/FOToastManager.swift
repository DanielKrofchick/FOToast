//
//  FOToastManager.swift
//  Pods
//
//  Created by Daniel Krofchick on 2016-06-28.
//
//

import Foundation

public struct FOToastManager {
    
    public static var sharedInstance = FOToastManager()
    
    public var window: UIWindow? = nil
    public var queue = NSOperationQueue()
    
    init() {
        queue.maxConcurrentOperationCount = 1
    }
    
    public mutating func add(toast: FOToast) {
        queue.addOperation(FOCompletionOperation(work: {
            operation in
            self.show(toast, completion: {
                finished in
                delay(toast.duration, closure: { 
                    self.hide(toast, completion: {
                        finished in
                        operation.finish()
                    })
                })
            })
        }, queue: dispatch_get_main_queue()))
    }
    
    mutating func show(toast: FOToast, completion: ((Bool)->())? = nil) {
        if let view = view() {
            view.addSubview(toast.view)
            toast.view.frame = toast.startFrame(view)
            
            UIView.animateWithDuration(toast.animationTime, animations: {
                toast.view.frame = toast.middleFrame(view)
            }, completion: completion)
        }
    }
    
    mutating func hide(toast: FOToast, completion: ((Bool)->())? = nil) {
        if let view = view() {
            UIView.animateWithDuration(toast.animationTime, animations: {
                toast.view.frame = toast.endFrame(view)
            }, completion: {
                finished in
                toast.view.removeFromSuperview()
                completion?(finished)
            })
        }
    }
    
    mutating func view() -> UIView? {
        if window == nil {
            if let keyWindow = UIApplication.sharedApplication().keyWindow {
                window = UIWindow()
                window?.frame = keyWindow.frame
                window?.hidden = false
                window?.windowLevel = UIWindowLevelNormal
                window?.backgroundColor = UIColor.clearColor()
                window?.rootViewController = UIViewController()
            }
        }
        
        return window?.rootViewController?.view
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
