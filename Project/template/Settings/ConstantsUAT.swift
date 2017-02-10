//
//  ConstantsUAT.swift
//  template
//
//  Created by YAVUZ ÖZTÜRK on 10/02/2017.
//  Copyright © 2017 Templete Project INC. All rights reserved.
//

import Foundation

let connectionDebug = false
let defaultEndpointType = EndpointType.uat

extension AppDelegate {
    func initializeGlobals() {
        initializeNSURLSessionConfiguration()
        initializeEndpointType()
        initializeAppearance()
    }
}
