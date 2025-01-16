//
//  Constants.swift
//  PreventCapturing
//
//  Created by ToTo on 16/1/25.
//

//

import UIKit

enum AppearanceConstants {

    enum Tag {
        static let blurEffectView = 11
    }
}
private enum Constants {
    enum Layout {
        static let infoLabelHorizontalIndent = 20.0
    }
}

// MARK: - UIViewController Extension
extension UIViewController {
    func enableSecureScreen(for contentView: UIView? = nil) {
//        SecureScreenManager.shared.showScreenShield()
        SecureScreenManager.shared.secureViewController(self, contentView: contentView)
    }
    func topMostViewController() -> UIViewController {
        // Handle presented view controller
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
        
        // Handle navigation controller
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topMostViewController() ?? self
        }
        
        // Handle tab bar controller
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topMostViewController() ?? self
        }
        
        return self
    }
    func popupVcFullScreen(storyboard: String, identifier: String) -> UIViewController {
        let vc = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        return vc
    }
}
// MARK: - UIViewController Extension
extension UIView {
    
    func pin(_ type: NSLayoutConstraint.Attribute) {
    translatesAutoresizingMaskIntoConstraints = false
    let constraint = NSLayoutConstraint(item: self, attribute: type,
                                        relatedBy: .equal,
                                        toItem: superview, attribute: type,
                                        multiplier: 1, constant: 0)

    constraint.priority = UILayoutPriority.init(999)
    constraint.isActive = true
}
    
    func pinEdges() {
        pin(.top)
        pin(.bottom)
        pin(.leading)
        pin(.trailing)
    }
}

