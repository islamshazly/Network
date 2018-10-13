//
//  UserAPI.swift
//  Network-AG_Example
//
//  Created by Islam Elshazly on 9/27/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Network_AG
import Alamofire

enum UserAPI: Network_AG.Request {
    
    case login
    case logout
    case signup
    
    var baseURL: URL {
        return URL(string: "http://api.emiratesauction.com/v2/carsonline")!
    }
    
    var path: String {
        switch self {
        case .login:
            return baseURL.absoluteString
        case.logout:
            return baseURL.absoluteString
        case.signup:
            return baseURL.absoluteString
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .get
        case.logout:
            return .get
        case.signup:
            return .post
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .login:
            return URLEncoding.queryString
        case.logout:
            return URLEncoding.queryString
        case.signup:
            return URLEncoding.queryString
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .login:
            return [:]
        case.logout:
            return [:]
        case.signup:
            return [:]
        }
    }
    
    var cachPolicy: NSURLRequest.CachePolicy {
        return .reloadIgnoringLocalCacheData
    }
}
