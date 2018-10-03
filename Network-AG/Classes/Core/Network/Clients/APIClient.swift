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
    func upload<T: Decodable>(data: Data, request: Request, result: @escaping ResultHandler<T>)
    func cancelRequests()
    
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
    
    public func upload<T>(data: Data, request: Request, result: @escaping ResultHandler<T>) where T: Decodable {
        
        logRequest(request)
        sharedSessionManager.upload(data, to: request.fullURL, method: request.method, headers: request.headers).responseObject {(response: DataResponse<T>) in
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
    
    public func cancelRequests() {
        
        XCGLogger.default.debug("======= CANCEL REQUESTS =======")
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, _ , _  in
            dataTasks.forEach { $0.cancel() }
   
        }
        XCGLogger.default.debug("===============================")
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
