//
//  ConstantsMock.swift
//  template
//
//  Created by YAVUZ ÖZTÜRK on 10/02/2017.
//  Copyright © 2017 Templete Project INC. All rights reserved.
//

import Foundation

let mockServer = MockHttpServer()
let connectionDebug = true
let defaultEndpointType = EndpointType.mock

extension AppDelegate {
    func initializeGlobals() {
        _ = mockServer
        initializeNSURLSessionConfiguration()
        initializeEndpointType()
        initializeAppearance()
    }
}
