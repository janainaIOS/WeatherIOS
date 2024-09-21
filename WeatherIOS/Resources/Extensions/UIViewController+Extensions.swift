//
//  UIViewController+Extensions.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import UIKit

extension UIViewController {
    
    /// Custom button action to dismiss/pop viewcontroller
    @IBAction func backClicked(_ sender: Any) {
        if self.isBeingPresented || self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /// To open settings for resources permission
    func appPermissionAlert(type: String) {
        let alertController = UIAlertController (title: "", message: "Please enable your \(type) in Settings to continue", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// Custom sheetPresentationController, pass viewcontroller and height of sheet view
    func configureSheet(vc: UIViewController, height: CGFloat)  {
        if let sheet = vc.sheetPresentationController {
            if #available(iOS 16.0, *) {
                let fraction = UISheetPresentationController.Detent.custom { context in
                    height // height is the view.frame.height of the view controller which presents this bottom sheet
                }
                sheet.detents = [fraction]
            } else {
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .medium
            }
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
    }
    
    // MARK: - Navigation
    
    public func presentViewController<T: UIViewController>(_ viewController: T.Type, storyboard: UIStoryboard, configure: ((T) -> Void)? = nil) {
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: viewController)) as! T
        configure?(vc)
        present(vc, animated: true)
    }
    
    public func presentSheetViewController<T: UIViewController>(_ viewController: T.Type, storyboard: UIStoryboard, height: CGFloat, configure: ((T) -> Void)? = nil) {
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: viewController)) as! T
        configure?(vc)
        configureSheet(vc: vc, height: height)
        present(vc, animated: true)
    }
    
    public func presentOverViewController<T: UIViewController>(_ viewController: T.Type, storyboard: UIStoryboard, configure: ((T) -> Void)? = nil) {
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: viewController)) as! T
        vc.modalPresentationStyle = .overFullScreen
        configure?(vc)
        present(vc, animated: true)
    }
    
    public func navigateToViewController<T: UIViewController>(_ viewController: T.Type, storyboard: UIStoryboard, configure: ((T) -> Void)? = nil) {
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: viewController)) as! T
        configure?(vc)
        navigationController?.pushViewController(vc, animated: true)
    }
}
