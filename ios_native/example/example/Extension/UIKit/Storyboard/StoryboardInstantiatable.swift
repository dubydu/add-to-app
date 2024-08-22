//
//  Created by DU on 22/03/2021.
//

import UIKit

// MARK: - Storyboard & UIViewController

protocol StoryboardInstantiatable { }

extension UIViewController: StoryboardInstantiatable { }

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}

extension StoryboardInstantiatable where Self: UIViewController {

    static func instantiateFromStoryboardWithIdentifier(storyboardName: String = Self.className, in bundle: Bundle? = nil, with identifier: String = Self.className) -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("UIViewController could not create.")
        }
        return viewController
    }

    static func instantiateInitialFromStoryboard(storyboardName: String = Self.className, in bundle: Bundle? = nil) -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("UIViewController could not create from \(storyboardName).")
        }
        return viewController
    }

    static func instantiateNavigationFromStoryboard(storyboardName: String = Self.className, in bundle: Bundle? = nil) -> (navigationController: UINavigationController, rootViewController: Self) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            fatalError("UINavigationController could not create from \(storyboardName).")
        }
        guard let viewController = navigationController.topViewController as? Self else {
            fatalError("UIViewController could not find from \(storyboardName).")
        }
        return (navigationController, viewController)
    }

    static func instantiateTabBarFromStoryboard(storyboardName: String = Self.className, in bundle: Bundle? = nil) -> (tabBarController: UITabBarController, rootViewControllers: [UIViewController]) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let tabBarController = storyboard.instantiateInitialViewController() as? UITabBarController else {
            fatalError("UITabBarController could not create from \(storyboardName).")
        }
        guard let viewControllers = tabBarController.viewControllers else {
            fatalError("UIViewControllers could not find from \(storyboardName).")
        }
        return (tabBarController, viewControllers)
    }
}
