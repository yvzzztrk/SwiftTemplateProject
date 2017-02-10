//
//  AppDelegate+Reachability.swift
//  template
//
//  Created by YAVUZ ÖZTÜRK on 10/02/2017.
//  Copyright © 2017 Templete Project INC. All rights reserved.
//

import Foundation
import UIKit
import ReachabilitySwift

protocol ReachabilityDelegate {
    func whenReachable()
    func whenUnReachable()
    func failReachability()
}

extension AppDelegate: ReachabilityDelegate {

    func startReachabilityNotifier() {
        do {
            try reachability!.startNotifier()
        } catch {
            self.failReachability()
        }

        reachability!.whenReachable = { reachability in
            self.whenReachable()
        }

        reachability!.whenUnreachable = { reachability in
            self.whenUnReachable()
        }
    }

    func whenReachable() {
        DispatchQueue.main.async {
            //TODO: when reachable
        }
    }

    func whenUnReachable() {
        DispatchQueue.main.async {
            //TODO: when reachable
        }
    }

    func failReachability() {
        debugPrint("Unable to proceed with Reachability")
    }
}
