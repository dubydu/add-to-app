/*
  Copyright © 2021 DUBYDU

  This software is provided 'as-is', without any express or implied warranty.
  In no event will the authors be held liable for any damages arising from
  the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
  claim that you wrote the original software. If you use this software in a
  product, an acknowledgment in the product documentation would be
  appreciated but is not required.

  2. Altered source versions must be plainly marked as such, and must not be
  misrepresented as being the original software.

  3. This notice may not be removed or altered from any source distribution.
 */

import UIKit
import Flutter
import FlutterPluginRegistrant

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// Window
    var window: UIWindow?
    /// Singleton
    static var shared = UIApplication.shared.delegate as? AppDelegate
    /// FlutterEngineGroup
    let flutterEngine = FlutterEngineGroup(name: "flutter-engines", project: nil)

    /// Did finish launching the app
    ///
    /// - Parameters:
    ///   - application: UIApplication
    ///   - launchOptions: [UIApplication.LaunchOptionsKey: Any]
    /// - Returns: Bool
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initialApplication()
        return true
    }

    /// Initialize Application
    private func initialApplication() {
        window = UIWindow(frame: UIScreen.main.bounds)
        self.transitionRootViewController(in: window)
    }
    
    /// Setup root viewcontroller
    ///
    /// - Parameter window: UIWindow
    func transitionRootViewController(in window: UIWindow?) {
        let viewController = HomeViewController.instantiateInitialFromStoryboard()
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()
    }
}
