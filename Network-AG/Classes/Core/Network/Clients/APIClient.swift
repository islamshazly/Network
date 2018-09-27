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

public typealias NetworkSuccessClosure = (Mappable?) -> Void
public typealias NetworkFailureClosure = (Error?) -> Void
public typealias NetworkResponse = (Mappable?, Error?)

enum APIResult<Value: Mappable, Error: Swift.Error & Equatable> {
    case success(Value)
    case error(Error)
}


public protocol APIClient: class {
    
    func startRequest<T: Mappable, A: APIRequest>(request: A, mappingClass: T, with successHandler: @escaping NetworkSuccessClosure, failureHandler: @escaping NetworkFailureClosure)
    
    func startRequest<T: Mappable, A: APIRequest>(request: A, mappingClass: T, withResult result: Result<NetworkResponse> )

    func restartLastRequest(successHandler: NetworkSuccessClosure, failureHandler: NetworkFailureClosure)
    func restartFailedRequests(successHandler: NetworkSuccessClosure, failureHandler: NetworkFailureClosure)
    func cancelRequests()
}
