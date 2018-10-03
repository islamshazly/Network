//
//  Client.swift
//  Doobo Test
//
//  Created by Islam Elshazly on 9/18/18.
//  Copyright © 2018 Areeb Group. All rights reserved.
//

import Foundation
import Alamofire
import XCGLogger

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
    func stopRequests()
}

extension APIClient {
    
    public func start<T>(request: Request, result: @escaping ResultHandler<T>) where T: Decodable {
        
        logRequest(request)
        sharedSessionManager.request(request)
                            .responseObject { (response: DataResponse<T>) in
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
    
    public func stopRequests() {
        
        XCGLogger.default.debug("======= STOP REQUESTS =======")
        sharedSessionManager.session.invalidateAndCancel()
    }
    
    func logRequest(_ request: Request) {
        
        XCGLogger.default.debug("======= REQUEST START =======")
        XCGLogger.default.debug("= URL " + request.fullURL)
        XCGLogger.default.debug("= PARAMTERS " + String(describing: request.parameters))
        XCGLogger.default.debug("= HEADERS " + String(describing: request.headers))
        XCGLogger.default.debug("= HTTPMETHOD " + String(describing: request.method))
        XCGLogger.default.debug("======= REQUEST End=======" + "\n")
        
    }
}
