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

public enum APIResult<Value, Error> {
    case success(Value)
    case error(Error)
}

public typealias ResultHandler = (APIResult<Mappable, Error>) -> Void

public protocol APIClient: class {
    
    func startRequest<T: Mappable, A: APIRequest>(request: A, mappingClass: T, with successHandler: @escaping NetworkSuccessClosure, failureHandler: @escaping NetworkFailureClosure)
    
    func startRequest<T: Mappable, A: APIRequest>(request: A, mappingClass: T, withResult result: ResultHandler )

    func restartLastRequest(successHandler: NetworkSuccessClosure, failureHandler: NetworkFailureClosure)
    func restartFailedRequests(successHandler: NetworkSuccessClosure, failureHandler: NetworkFailureClosure)
    func cancelRequests()
}
