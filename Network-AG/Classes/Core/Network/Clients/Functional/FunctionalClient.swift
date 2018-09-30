//
//  ClientOne.swift
//  Doobo Test
//
//  Created by Islam Elshazly on 9/17/18.
//  Copyright © 2018 Areeb Group. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper


public protocol FunctionalClient: APIClient {
    
    var request: APIRequest? {get set}
    
}

public extension FunctionalClient {
    
    func startRequest<T: Mappable, A: APIRequest>(request: A, mappingClass: T, with successHandler: @escaping NetworkSuccessClosure, failureHandler: @escaping NetworkFailureClosure) {
        
        logger(with: "Request URL:", data: request.path)
        logger(with: "Request Paramters:", data: request.parameters?.debugDescription ?? "error")
        logger(with: "Request Header:", data: request.headers?.debugDescription ?? "error")
        
        Alamofire.request(request.path, method: request.method, parameters: request.parameters, encoding: request.parameterEncoding, headers: request.headers).responseJSON { [weak self] (response :DataResponse<Any>) in
            
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    
                    self?.logger(with: "Response:", data: data)
                    let model = Mapper<T>().map(JSONObject: data, toObject: mappingClass)
                    successHandler(model)
                }
                break
                
            case .failure(_):
                self?.logger(with: "Error: ", data: response.result.error?.localizedDescription)
                failureHandler(response.result.error)
                break
            }
        }
    }
    
    func startRequest<T: Mappable, A: APIRequest>(request: A, mappingClass: T, withResult result: @escaping ResultHandler) {
        
        Alamofire.request(request.path, method: request.method, parameters: request.parameters, encoding: request.parameterEncoding, headers: request.headers).responseJSON { [weak self] (response :DataResponse<Any>) in
            
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    self?.logger(with: "Response:", data: data)
                    let model = Mapper<T>().map(JSONObject: data, toObject: mappingClass)
                    result(.success(model))
                }
                break
                
            case .failure(_):
                let error = response.result.error
                result(.failure(error!))
                self?.logger(with: "Error: ", data: response.result.error?.localizedDescription)
                
                break
            }
        }
    }
    
    func restartLastRequest(successHandler: NetworkSuccessClosure, failureHandler: NetworkFailureClosure) {
        
    }
    
    func restartFailedRequests(successHandler: NetworkSuccessClosure, failureHandler: NetworkFailureClosure) {
        
    }
    
    func cancelRequests() {
        
    }
    
    func logger(with title: String, data:Any) {
        #if DEBUG
        print(title + "Request URL: \(String(describing: data))")
        #endif
    }
}


