//
//  ConstantsDev.swift
//  template
//
//  Created by YAVUZ ÖZTÜRK on 10/02/2017.
//  Copyright © 2017 Templete Project INC. All rights reserved.
//

import Foundation

let connectionDebug = true
let defaultEndpointType = EndpointType.dev

extension AppDelegate {
    func initializeGlobals() {
        initializeNSURLSessionConfiguration()
        initializeEndpointType()
        initializeAppearance()
    }
}
