//
//  Dictionary+TryCasting.swift
//  template
//
//  Created by YAVUZ ÖZTÜRK on 10/02/2017.
//  Copyright © 2017 Templete Project INC. All rights reserved.
//

import Foundation

public enum CastingError: Error, DisplayableErrorType, CastingErrorKey {
    case Failure(key: String)

    var key: String? {
        switch self {
        case .Failure(let key):
            return key
        }
    }

    var errorMessage: String? {
        switch self {
        case .Failure(let key):
            return "Casting Error: \(key)"
        }
    }
}

protocol CastingErrorKey {
    var key: String? { get }
}

// Helper functions for Dictionary to get values with certain type or throw
extension Dictionary {

    func get<T>(_ key: String) throws -> T {
        guard let keyAs = key as? Key else {
            throw CastingError.Failure(key: "-")
        }
        guard let obj = self[keyAs], let objAs = obj as? T else {
            throw CastingError.Failure(key: key)
        }
        return objAs
    }

    func get<T: RawRepresentable>(_ key: String) throws -> T {
        guard let keyAs = key as? Key else {
            throw CastingError.Failure(key: "-")
        }
        guard let obj = self[keyAs], let objAs = obj as? T.RawValue else {
            throw CastingError.Failure(key: key)
        }
        guard let value = T(rawValue: objAs) else {
            throw CastingError.Failure(key: key)
        }
        return value
    }

    func get<T: JsonInitializable>(_ key: String) throws -> T {
        guard let keyAs = key as? Key else {
            throw CastingError.Failure(key: "-")
        }
        guard let obj = self[keyAs], let objAs = obj as? [String: AnyObject] else {
            throw CastingError.Failure(key: key)
        }
        return try T(json: objAs)
    }

    func get<T: JsonInitializable>(_ key: String) throws -> [T] {
        guard let keyAs = key as? Key else {
            throw CastingError.Failure(key: "-")
        }
        guard let obj = self[keyAs], let objAs = obj as? [[String: AnyObject]] else {
            throw CastingError.Failure(key: key)
        }
        return try objAs.map { try T(json: $0) }
    }

    func convert<T: JsonInitializable>() throws -> [Key: T] {
        var result: [Key: T] = [:]
        for (key, innerObj) in self {
            guard let obj = innerObj as? [String: AnyObject] else {
                throw CastingError.Failure(key: "Convert")
            }
            result[key] = try T(json: obj)
        }
        return result
    }

    func getOptional<T>(_ key: String) throws -> T? {
        guard let keyAs = key as? Key else {
            throw CastingError.Failure(key: "-")
        }
        guard let obj = self[keyAs], !(obj is NSNull) else {
            return nil
        }
        guard let objAs = obj as? T else {
            throw CastingError.Failure(key: key)
        }
        return objAs
    }

    func getOptional<T: RawRepresentable>(_ key: String) throws -> T? {
        guard let keyAs = key as? Key else {
            throw CastingError.Failure(key: "-")
        }
        guard let obj = self[keyAs], !(obj is NSNull) else {
            return nil
        }
        guard let objAs = obj as? T.RawValue else {
            throw CastingError.Failure(key: key)
        }
        guard let value = T(rawValue: objAs) else {
            throw CastingError.Failure(key: key)
        }
        return value
    }

    func getOptional<T: JsonInitializable>(_ key: String) throws -> T? {
        guard let keyAs = key as? Key else {
            throw CastingError.Failure(key: "-")
        }
        guard let obj = self[keyAs], !(obj is NSNull) else {
            return nil
        }
        guard let objAs = obj as? [String: AnyObject] else {
            throw CastingError.Failure(key: key)
        }
        return try T(json: objAs)
    }

    func getOptional<T: JsonInitializable>(_ key: String) throws -> [T]? {
        guard let keyAs = key as? Key else {
            throw CastingError.Failure(key: "-")
        }
        guard let obj = self[keyAs], !(obj is NSNull) else {
            return nil
        }
        guard let objAs = obj as? [[String: AnyObject]] else {
            throw CastingError.Failure(key: key)
        }
        return try objAs.map { try T(json: $0) }
    }
}
