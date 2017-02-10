//
//  NetworkUtility.swift
//  template
//
//  Created by YAVUZ ÖZTÜRK on 10/02/2017.
//  Copyright © 2017 Templete Project INC. All rights reserved.
//

import Foundation

typealias JSON = [String : AnyObject]

protocol JsonInitializable {
    init (json: JSON) throws
}

protocol JsonConvertable {
    func toJson() -> JSON
}

enum RouterError: Error, DisplayableErrorType {
    case DataTypeMismatch
    case HiddenError //error message is not shown for some cases like 401

    var errorMessage: String? {
        switch self {
        case .DataTypeMismatch:
            return Localize.Error.Generic
        case .HiddenError:
            return nil
        }
    }
}

protocol DisplayableErrorType {
    var errorMessage: String? { get }
}

extension String {
    func convertToJson () -> JSON {
        let data = self.data(using: String.Encoding.utf8)
        let json = try! JSONSerialization.jsonObject(with: data!, options:[JSONSerialization.ReadingOptions.allowFragments]) as! JSON
        return json
    }
}

extension Dictionary where Key : ExpressibleByStringLiteral, Value : AnyObject {
    func toString() -> String {
        let data = try! JSONSerialization.data(withJSONObject:self as AnyObject, options: [])
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
        return string
    }
}

struct Localize {

    struct Error {
        static let Generic = NSLocalizedString("A problem occured, please try again.", comment: "A problem occured, please try again.")
    }

}
