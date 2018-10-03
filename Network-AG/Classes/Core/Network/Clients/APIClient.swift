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

public typealias APIResultHandler<T> = (APIResult<T, Swift.Error>) -> Void

public protocol APIClient: APILogger {
    
    // MARK: -  Properties
    
    var baseUrl: String { get }
    var defaultHeaders: [String: String] { get }
    var sharedSessionManager: SessionManager { get set }
    
    // MARK: - Public functions
    
    func start<T: Decodable>(request: Request, result: @escaping APIResultHandler<T>)
    func upload<T: Decodable>(data: Data, request: Request, result: @escaping APIResultHandler<T>)
    func cancelRequests()
    
}

extension APIClient {
    
    public func start<T>(request: Request, result: @escaping APIResultHandler<T>) where T: Decodable {
        logRequest(request)
        
        sharedSessionManager.request(request)
            .responseObject { [weak self] (response: DataResponse<T>) in
                guard let self = self else { return }
                self.resultHandler(response: response, result: result)
        }
    }
    
    public func upload<T>(data: Data, request: Request, result: @escaping APIResultHandler<T>) where T: Decodable {
        logRequest(request)
        
        sharedSessionManager.upload(data, to: request.fullURL, method: request.method, headers: request.headers).responseObject {[weak self ] (response: DataResponse<T>) in
            guard let self = self else { return }
            self.resultHandler(response: response, result: result)
        }
    }
    
    private func resultHandler<T: Decodable>(response: DataResponse<T>, result: @escaping APIResultHandler<T>) {
        switch response.result {
        case .success(let model):
            result(.success(model))
        case.failure(let error):
            result(.failure(error))
        }
    }
    
    public func cancelRequests() {
        sharedSessionManager.session.getTasksWithCompletionHandler { dataTasks, _ , _  in
            dataTasks.forEach { $0.cancel() }
        }
        logger("======= CANCEL REQUESTS =======")
    }
    
    private func logRequest(_ request: Request) {
        logger("======= REQUEST START =======")
        logger("= URL " + request.fullURL)
        logger("= PARAMTERS " + String(describing: request.parameters))
        logger("= HEADERS " + String(describing: request.headers))
        logger("= HTTPMETHOD " + String(describing: request.method))
        logger("======== REQUEST END =========" + "\n")
    }
}
