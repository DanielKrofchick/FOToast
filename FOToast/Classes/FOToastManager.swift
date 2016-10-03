//
//  FOToastManager.swift
//  Pods
//
//  Created by Daniel Krofchick on 2016-06-28.
//
//

import Foundation

open class FOToastManager: NSObject {
    
    open static var sharedInstance = FOToastManager()
    
    open var window: UIWindow? = nil
    open var queue = OperationQueue()
    var currentToast: FOToast? = nil
    
    override init() {
        super.init()
        
        queue.maxConcurrentOperationCount = 1
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeStatusBarFrame), name: NSNotification.Name.UIApplicationDidChangeStatusBarFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open func add(_ toast: FOToast) {
        if !toast.hasContent() {
            return
        } else if let identifier = toast.identifier() {
            if identifier == currentToast?.identifier() {
                return
            }
        }
        
        toast.toastManager = self

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
        }, queue: DispatchQueue.main))
    }
    
    func addBackgroundTap(_ toast: FOToast) {
        toast.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doBackgroundtap)))
    }
    
    func doBackgroundtap() {
        if let currentToast = currentToast {
            currentToast.backgroundTap?()
            hide(currentToast)
        }
    }
    
    func show(_ toast: FOToast, animated: Bool = true, completion: ((Bool)->())? = nil) {
        if let view = view() {
            currentToast = toast
            view.addSubview(toast.view)
            toast.view.frame = toast.startFrame(view)
            
            UIView.animate(withDuration: animated ? toast.animationTime : 0, animations: {
                toast.view.frame = toast.middleFrame(view)
            }, completion: completion)
        }
    }
    
    open func hide(_ toast: FOToast, animated: Bool = true, completion: ((Bool)->())? = nil) {
        if let view = view() {
            UIView.animate(withDuration: animated ? toast.animationTime : 0, animations: {
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
            if let keyWindow = UIApplication.shared.keyWindow {
                window = TouchForwardingWindow()
                window?.frame = keyWindow.frame
                window?.isHidden = false
                window?.windowLevel = UIWindowLevelNormal
                window?.backgroundColor = UIColor.clear
                window?.rootViewController = UIViewController()
            }
        }
        
        return window?.rootViewController?.view
    }
    
    func didChangeStatusBarFrame() {
        if let
            currentToast = currentToast,
            let view = view()
        {
            currentToast.view.frame = currentToast.update(view)
        }
    }
    
}

class TouchForwardingWindow: UIWindow {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var hitView = super.hitTest(point, with: event)
        
        if hitView == rootViewController?.view {
            hitView = nil
        }
        
        return hitView
    }
    
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
