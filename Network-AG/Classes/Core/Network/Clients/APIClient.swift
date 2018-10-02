//
//  Client.swift
//  Doobo Test
//
//  Created by Islam Elshazly on 9/18/18.
//  Copyright © 2018 Areeb Group. All rights reserved.
//

import Foundation
import Alamofire

public enum APIResult<Value, Error> {
    case success(Value)
    case failure(Swift.Error)
}

public typealias ResultHandler<T> = (APIResult<T, Swift.Error>) -> Void

public protocol APIClient: class {
    
    // MARK: -  Properties
    
    var baseUrl: String { get }
    var defaultHeaders: [String: String] { get }
    var sharedSessionManager: SessionManager { get set }
    
    // MARK: - Public functions
    
    func start<T: Decodable>(request: Request, result: @escaping ResultHandler<T>)
    
}

extension APIClient {
    
    public func start<T>(request: Request, result: @escaping ResultHandler<T>) where T: Decodable {
        
        sharedSessionManager.request(request.path, method: request.method,
                                     parameters: request.parameters,
                                     encoding: request.parameterEncoding,
                                     headers: request.headers).responseObject { (response: DataResponse<T>) in
                                        switch response.result {
                                        case .success(let model):
                                            result(.success(model))
                                            break
                                        case.failure(let error):
                                            result(.failure(error))
                                            break
                                        }
        }
        
    }
}
