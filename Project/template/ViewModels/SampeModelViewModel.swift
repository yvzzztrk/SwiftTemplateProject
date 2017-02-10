//
//  SampeModelViewModel.swift
//  template
//
//  Created by YAVUZ ÖZTÜRK on 10/02/2017.
//  Copyright © 2017 Templete Project INC. All rights reserved.
//

import Foundation
import PromiseKit

struct SampleModelViewModel {

    let sampleStringInfo: String

    init(sampleModel: SampleModel) {

        sampleStringInfo = sampleModel.sampleString
    }
}

extension Promise where T: SampleModel {
    func toViewModel() -> Promise<SampleModelViewModel> {
        return self.then(execute: { (response) in
            return SampleModelViewModel(sampleModel: response)
        })
    }
}
