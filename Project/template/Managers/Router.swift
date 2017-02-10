//
//  Router.swift
//  template
//
//  Created by YAVUZ ÖZTÜRK on 10/02/2017.
//  Copyright © 2017 Templete Project INC. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

enum Router {

    typealias Route = (method: Alamofire.HTTPMethod, path: String, parameters: [String : AnyObject]?, responseType: JsonInitializable.Type, encoding: Alamofire.ParameterEncoding)

    static var baseURL = NSURL()

    static let alamofireManager = Alamofire.SessionManager(configuration:sessionConfiguration)

    case SampleModelRequest

    private func routeWithPathVariableAndParameters(value: String = "", parameters: [String : AnyObject]? = nil) -> Route? {

        if defaultEndpointType == .mock {
            switch self {
            case .SampleModelRequest:
                return (.get, "schedule_changes.json", nil, SampleModel.self, URLEncoding.default)
            }
        } else {
            switch self {
            case .SampleModelRequest:
                return (.get, "apiEndpoint", nil, SampleModel.self, URLEncoding.default)
            }
        }
    }

    func promise<T: JsonInitializable>(path: String = "", parameters: [String : AnyObject]? = nil) -> Promise<T> {
        return Promise<AnyObject?> { fulfill, reject in

            UIApplication.shared.isNetworkActivityIndicatorVisible = true

            guard let route = self.routeWithPathVariableAndParameters(value: path, parameters: parameters) else {
                throw RouterError.HiddenError
            }

            request(route: route, path: path, parameters: parameters, completion: { (response) in
                switch response.result {
                case .success:
                    fulfill(response.result.value! as AnyObject?)
                case .failure(let error):
                    reject(error)
                }
            })

            }.then { data -> T in
                guard let json = data as? [String: AnyObject] else {
                    throw RouterError.DataTypeMismatch
                }
                do {
                    let obj = try self.routeWithPathVariableAndParameters(value: path, parameters: parameters)!.responseType.init(json: json) as? T
                    return obj!
                } catch let castingError as CastingError {
                    throw CastingError.Failure(key: castingError.key!)
                }
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    func request(route: Route, path: String, parameters: [String : AnyObject]?, completion: @escaping (DataResponse<Any>) -> Void ) {
        let url: String = "\(baseUrlString)\(route.path)"
        Router.alamofireManager.request(url, method: route.method, parameters: route.parameters, encoding: route.encoding, headers: nil).validate().responseJSON { (response) in
                debugPrint(response)
                completion(response)
        }
    }

}
