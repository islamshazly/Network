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
import ObjectMapper
import AlamofireObjectMapper

public enum APIResult<Value, Error> {
    case success(Value)
    case failure(Swift.Error)
}

public typealias APIResultHandler<T> = (APIResult<T, Swift.Error>) -> Void

public protocol APIClient: class {
    
    // MARK: -  Properties
    
    var baseUrl: String { get }
    var defaultHeaders: [String: String] { get }
    var sharedSessionManager: SessionManager { get set }
    var lastRequest: Request? { get set }
    var result: APIResultHandler<Mappable>? { get set}
    
    // MARK: - Public functions

    func start<T: Mappable>(request: Request, result: @escaping APIResultHandler<T>)
    func upload<T: Mappable>(data: Data, request: Request, result: @escaping APIResultHandler<T>)
    func cancelRequests()
}

extension APIClient {
    
    
    public func start<T>(request: Request, result: @escaping APIResultHandler<T>) where T: Mappable {
        Logger.request(request)
        self.lastRequest = request
        sharedSessionManager.session.configuration.requestCachePolicy = request.cachPolicy
        sharedSessionManager.request(request).responseObject { [weak self] (response: DataResponse<T>) in
            guard let self = self else { return }
            self.resultHandler(response: response, result: result)
        }
    }
    
    public func upload<T>(data: Data, request: Request, result: @escaping APIResultHandler<T>) where T: Mappable {
        Logger.request(request)
        
        sharedSessionManager.upload(data, to: request.fullURL, method: request.method, headers: request.headers).responseObject {[weak self ] (response: DataResponse<T>) in
            guard let self = self else { return }
            self.resultHandler(response: response, result: result)
        }
    }
    
    private func resultHandler<T: Mappable>(response: DataResponse<T>, result: @escaping APIResultHandler<T>) {
        switch response.result {
        case .success(let model):
            Logger.response(model.toJSONString() ?? "")
            result(.success(model))
        case.failure(let error):
            Logger.error(error)
            result(.failure(error))
        }
    }
    
    private func retry(_ request: Request, error: Error) {

        // fake error code 400 to make alamofire determine to retry
        
//        let cancelError = NSError(domain: "http://www.islam.com", code: 400, userInfo: [:])
        sharedSessionManager.retrier?.retryRequest(seesion: sharedSessionManager, request: request, retrying: error, requestRetryCompletion: { (bool, timeIntervale) in
            Logger.debug("retry sucess")
        })
    }
    
    public func cancelRequests() {
        let session = Alamofire.SessionManager.default
        session.session.getTasksWithCompletionHandler { dataTasks, _ , _  in
            dataTasks.forEach { $0.cancel() }
        }
        Logger.debug("======= CANCEL REQUESTS =======")
    }
    
}
