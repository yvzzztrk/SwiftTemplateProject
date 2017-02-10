//
//  SampleModel.swift
//  template
//
//  Created by YAVUZ ÖZTÜRK on 10/02/2017.
//  Copyright © 2017 Templete Project INC. All rights reserved.
//

import Foundation


class SampleModel: JsonConvertable, JsonInitializable {
    
    let sampleString: String
    
    required init(json: JSON) throws {
        
        sampleString = try json.get("sampleString")
    }
    
    func toJson() -> JSON {
        
        var json: JSON = JSON()
        json["sampleString"] = sampleString as AnyObject?
        return json
        
    }
}
