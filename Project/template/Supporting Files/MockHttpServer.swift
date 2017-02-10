//
//  AppDelegate.swift
//  templete
//
//  Created by YAVUZ ÖZTÜRK on 10/02/2017.
//  Copyright © 2017 Templete Project INC. All rights reserved.
//

import Foundation
import Swifter

open class MockHttpServer: HttpServer {

    override init() {
        super.init()

        let mainBundleResourcePath: NSString = Bundle.main.resourcePath! as NSString
        let mockServerFolder = mainBundleResourcePath.appendingPathComponent("MockData")
        self["/api/:path"] = shareFilesFromDirectory(mockServerFolder)

        do {
            try self.start(3_000)
        } catch SocketError.acceptFailed(let message) {
            debugPrint(message)
        } catch {
            debugPrint("Mock Server Error")
        }
    }
}
