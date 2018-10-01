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
import XCGLogger

public protocol FunctionalClient: APIClient {
    
    var request: APIRequest? {get set}
    
}

extension Alamofire.DataRequest {
    
    func responseObject<T: Decodable>(model : T.Type, result: @escaping ResultHandler) {
        self.responseJSON { (response: DataResponse<Any>) in
            
            if response.result.error != nil {
                result(.failure(response.result.error!))
            } else {
                do {
                    print(T.self)
                    print("loggg")
                    let decoder = JSONDecoder()
                    let responseObject = try? decoder.decode(T.self, from: response.data!)
                    result(.success(responseObject))
                } catch let error  {
                    result(.failure(error))
                }
            }
        }
    }
    
}


public extension FunctionalClient {
    
    public func startRequest<T, A>(request: A, mappingClass: T, withResult result: @escaping ResultHandler) where T: Decodable, A: APIRequest {
        
        print(T.self)
        print("logasdasdgg")
        
        Alamofire.request(request.path, method: request.method, parameters: request.parameters, encoding: request.parameterEncoding, headers: request.headers).responseObject(model: T.self) { (resultHandler) in
            switch resultHandler {
            case .success(let model):
                result(.success(model))
                break
            case.failure(let error):
                result(.failure(error))
                break
            }
        }
        
    }
    
    func restartLastRequest(_ result: @escaping ResultHandler) {
        
    }
    
    func restartFailedRequests(_ result: @escaping ResultHandler) {
        
    }
    
    func cancelRequests() {
        
    }
    
    func logRequest() {
        
        
    }
    
}

