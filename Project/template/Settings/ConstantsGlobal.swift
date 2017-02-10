//
//  ConstantsGlobal.swift
//  template
//
//  Created by YAVUZ ÖZTÜRK on 10/02/2017.
//  Copyright © 2017 Templete Project INC. All rights reserved.
//

import UIKit
import PKHUD
import ReachabilitySwift

enum EndpointType: String {

    case mock = "mock"
    case dev = "test"
    case uat = "uat"
    case prod = "prod"

    var baseUrl: String {
        switch self {
        case .mock:
            return "http://localhost:3000/api/"
        case .dev:
            return "tbd"
        case .uat:
            return "tbd"
        case .prod:
            return "tbd"
        }
    }
}

var baseUrlString: String = ""
var endpointType: EndpointType? {
    didSet {
        if let endpointType = endpointType {
            baseUrlString = endpointType.baseUrl
            Router.baseURL = NSURL(string: baseUrlString)!
        }
    }
}

var sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default

extension AppDelegate {

    func initializeEndpointType() {
        let newEndpointType = loadEndpointType()
        if endpointType != newEndpointType {
            endpointType = newEndpointType
            initializeWindow()
        }
    }

    func initializeNSURLSessionConfiguration() {
        sessionConfiguration.timeoutIntervalForRequest = 10
        sessionConfiguration.timeoutIntervalForResource = 10
    }

    func initializeAppearance() {

        let normalStateAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)]
        UITabBarItem.appearance().setTitleTextAttributes(normalStateAttributes, for: .normal)

        PKHUD.sharedHUD.dimsBackground = true
    }

    internal func initializeWindow() {
        let w = UIWindow()
        w.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        w.frame = UIScreen.main.bounds
        w.backgroundColor = UIColor.white
        w.makeKeyAndVisible()
        self.window = w
    }

    func initializeReachability() {
        reachability = Reachability.init()
    }

    // MARK: -

    private func loadEndpointType() -> EndpointType {
        if let endpointString = UserDefaults.standard.string(forKey: "endpoint"), let endpoint = EndpointType(rawValue: endpointString) {
            return endpoint
        }
        return defaultEndpointType
    }

    // MARK: - CLASS FUNCS

    class func appVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let buildnumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return "Version \(version)\(endpointType == .prod ? "" : " (\(buildnumber))")"
        } else {
            return ""
        }
    }

    class func backToViewController(viewControllerClass: AnyClass, completion: (() -> Void)?) {

        if HUD.isVisible {
            HUD.hide()
        }

        let topViewController = AppDelegate.topViewController()!
        if topViewController.isKind(of: viewControllerClass) {
            guard completion != nil else {
                return
            }
            completion!()
        } else {
            topViewController.dismiss(animated: true, completion: {
                backToViewController(viewControllerClass: viewControllerClass, completion: completion)
            })
        }
    }

    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }

    class func showAlert(title: String, message: String, actions: [UIAlertAction]? = [UIAlertAction(title: "OK", style: .default, handler: nil)]) {
        let alertViewController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        actions?.forEach({ (action) in
            alertViewController.addAction(action)
        })

        // If any alert view is presented at this time
        if let presentedViewController = AppDelegate.topViewController()?.presentedViewController {
            if presentedViewController.isKind(of: UIAlertController.classForCoder()) {
                AppDelegate.topViewController()?.dismiss(animated: true, completion: {
                    topViewController()!.present(alertViewController, animated: true, completion: nil)
                })
            }
        } else {
            topViewController()!.present(alertViewController, animated: true, completion: nil)
        }
    }

    class func showActionSheet(title: String? = nil, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        for action in actions {
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        topViewController()!.present(alertController, animated: true, completion: nil)
    }
}
