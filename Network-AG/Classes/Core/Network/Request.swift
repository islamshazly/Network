//
//  Request.swift
//  Doobo Test
//
//  Created by Islam Elshazly on 9/17/18.
//  Copyright © 2018 Islam Elshazly. All rights reserved.
//

import Alamofire

public protocol Request {
    
    var baseURL: URL { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var parameterEncoding: ParameterEncoding { get }
    var headers: [String : String]? { get }
    var parameters: [String: Any]?  { get }
    var cachPolicy: NSURLRequest.CachePolicy { get }
}

extension Request {
    
    var fullURL: String {
        return self.baseURL.absoluteString + self.path
    }
    
    var imageName: String{
        return ""
    }
    
    var imageFileName: String {
        return ""
    }
}

