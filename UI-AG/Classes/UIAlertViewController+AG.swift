//
//  AlertViewController.swift
//

import UIKit

public extension UIAlertController {
    
    typealias alertAction = ((UIAlertAction) -> ())
    
    static func showErrorAlert(VC: UIViewController,title: String, meesage: String, action: alertAction?, completionHandler: (() -> Void)?)
    {
        let alert = UIAlertController(title: title, message: meesage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertActionStyle.default, handler: action))
        VC.present(alert, animated: true, completion: completionHandler)
    }
    
    static func showAlert(VC: UIViewController, title: String, meesage: String, action: alertAction?, cancelAction: alertAction?, completionHandler: (() -> Void)?)
    {
        let alert = UIAlertController(title: title, message: meesage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: UIAlertActionStyle.default, handler: action))
        VC.present(alert, animated: true, completion: completionHandler)
        alert.addAction(UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .cancel, handler: cancelAction))
        VC.present(alert, animated: true, completion: completionHandler)
    }
}
