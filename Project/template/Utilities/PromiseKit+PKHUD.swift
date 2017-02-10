//
//  PromiseKit+PKHUD.swift
//  template
//
//  Created by YAVUZ ÖZTÜRK on 10/02/2017.
//  Copyright © 2017 Templete Project INC. All rights reserved.
//

import Foundation
import PKHUD
import PromiseKit

extension Promise {

    func wrapWithHUD(showsHUD: Bool = true, showsError: Bool = true) -> Promise {
        let promise = DispatchQueue.global().promise {
            if showsHUD {
                DispatchQueue.main.async {
                    HUD.show(.progress)
                }
            }
            }.then {_ in
                return self
            }.then { response -> T in
                DispatchQueue.main.async {
                    HUD.hide()
                }
                return response
        }

        promise.catch { error in

            if showsError {
                DispatchQueue.main.async {
                    HUD.hide()
                    debugPrint(error.localizedDescription)
                    //TODO: cast error and show popup with error message
                }
            } else {
                DispatchQueue.main.async {
                    HUD.hide()
                }
            }

        }
        return promise
    }
}
