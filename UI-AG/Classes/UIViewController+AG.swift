
import UIKit

// MARK: - Properties

public extension UIViewController {
    
    public var isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return self.isViewLoaded && view.window != nil
    }
    
    public var isNavBarHidden: Bool {
        get {
            return (navigationController?.isNavigationBarHidden)!
        }
        set {
            navigationController?.isNavigationBarHidden = newValue
        }
    }
}

extension UIViewController {
    
    open var navigationBarColor: UIColor? {
        get {
            if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
                return visibleViewController.navigationBarColor
            }
            return navigationController?.navigationBar.tintColor
        } set(value) {
            navigationController?.navigationBar.barTintColor = value
        }
    }
}

// MARK: - Methods

extension UIViewController {
    
    public func topMostViewController(with root: UIViewController) -> UIViewController {
        if let tab = root as? UITabBarController {
            return self.topMostViewController(with: tab.selectedViewController!)
        }
        if let nav = root as? UINavigationController {
            return self.topMostViewController(with: nav.visibleViewController!)
        }
        if let presented = root.presentedViewController {
            return topMostViewController(with: presented)
        }
        
        return root
    }
    
    public func isModal() -> Bool {
        return self.presentingViewController?.presentedViewController == self
            || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController)
            || self.tabBarController?.presentingViewController is UITabBarController
    }
    
    open func popVC() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    open func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
