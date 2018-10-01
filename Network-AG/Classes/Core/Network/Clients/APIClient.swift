//
//  Client.swift
//  Doobo Test
//
//  Created by Islam Elshazly on 9/18/18.
//  Copyright © 2018 Areeb Group. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

public enum APIResult<Value, Error> {
    case success(Value)
    case failure(Swift.Error)
}

public typealias ResultHandler = (APIResult<Decodable, Swift.Error>) -> Void

public protocol APIClient: class {
    
    func startRequest<T: Decodable, A: APIRequest>(request: A, mappingClass: T, withResult result: @escaping ResultHandler)
    func restartLastRequest(_ result: @escaping ResultHandler)
    func restartFailedRequests(_ result: @escaping ResultHandler)
    func cancelRequests()
    
}
