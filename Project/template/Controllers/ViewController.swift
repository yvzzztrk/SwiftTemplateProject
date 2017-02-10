//
//  ViewController.swift
//  templete
//
//  Created by YAVUZ ÖZTÜRK on 10/02/2017.
//  Copyright © 2017 Templete Project INC. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        sampleRequset(showsHUD: false, showsError: false)
    }

    func sampleRequset (showsHUD: Bool, showsError: Bool) {
        firstly { () -> Promise<SampleModelViewModel> in
            return Router.SampleModelRequest.promise().toViewModel().wrapWithHUD(showsHUD: showsHUD, showsError: showsError)
            }.then { (viewModel) -> Void in
                debugPrint(viewModel.sampleStringInfo)
            }.catch { (_) in
                debugPrint("SampleModelRequest response error")
        }
    }
}
