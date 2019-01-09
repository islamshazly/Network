//
//  Request.swift
//  Doobo Test
//
//  Created by Islam Elshazly on 9/17/18.
//  Copyright © 2018 Islam Elshazly. All rights reserved.
//


import Alamofire

public protocol Request {
    
    // MARK: - Properties
    
    var baseURL: URL? { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var parameterEncoding: ParameterEncoding { get }
    var headers: [String : String]? { get }
    var parameters: [String: Any]?  { get }
    var cachPolicy: NSURLRequest.CachePolicy { get }
}

extension Request {
    
    // MARK: - Properties
    
    var fullURL: String? {
        guard baseURL != nil else { return nil }
        
        return self.baseURL!.absoluteString + self.path
    }
}

