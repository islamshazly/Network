//
//  UserAPI.swift
//  Network-AG_Example
//
//  Created by Islam Elshazly on 9/27/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Network_IS
import Alamofire

enum UserAPI: Network_IS.Request {
    
    var imageName: String{
        return "assdf"
    }
    
    var imageFileName: String {
        return "sdfsdf"
    }
    
    
    case login
    case logout
    case signup
    
    var baseURL: URL {
        return URL(string: "http://test.api.doobo.co/")!
    }
    
    var path: String {
        switch self {
        case .login:
            return ""
        case.logout:
            return "api/v1/registration/token/generate"
        case.signup:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .get
        case.logout:
            return .post
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
            return ["type" : "sms",
                    "countryCode" : "20",
                    "phoneNumber" : "343434343434"]
        case.signup:
            return [:]
        }
    }
    
    var cachPolicy: NSURLRequest.CachePolicy {
        return .returnCacheDataElseLoad
    }
}
