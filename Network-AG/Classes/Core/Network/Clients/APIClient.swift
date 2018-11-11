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
    case failure((ErrorPayload))
}

public typealias APIResultHandler<T> = (APIResult<T, ErrorPayload>) -> Void

public protocol APIClient: class {
    
    // MARK: -  Properties
    
    var baseUrl: String { get }
    var defaultHeaders: [String: String] { get }
    var sharedSessionManager: SessionManager { get set }
    var lastRequest: Request? { get set }
    var validStatusCodes: CountableClosedRange<Int> { get }
    
    // MARK: - Public functions
    
    func start<T: Model>(request: Request, result: @escaping APIResultHandler<T>)
    func upload<T: Model>(data: Data, request: Request, result: @escaping APIResultHandler<T>)
    func cancelRequests()
}

extension APIClient {
    
    public func start<T>(request: Request, result: @escaping APIResultHandler<T>) where T: Model {
        Logger.request(request)
        self.lastRequest = request
        sharedSessionManager.session.configuration.requestCachePolicy = request.cachPolicy
        sharedSessionManager.request(request).validate(statusCode: self.validStatusCodes)
            .responseObject { [weak self] (response: DataResponse<T>) in
                guard let self = self else { return }
                self.resultHandler(response: response, result: result)
        }
    }
    
    public func upload<T>(data: Data, request: Request, result: @escaping APIResultHandler<T>) where T: Model {
        Logger.request(request)
        sharedSessionManager.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(data, withName: request.imageName!, fileName: request.imageFileName!, mimeType: "image/*")
            for (key, value) in request.parameters! {
                if let stringValue = value as? String {
                    multipartFormData.append(stringValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, to:request.fullURL, method: request.method, headers: request.headers)
        { (responseResult: SessionManager.MultipartFormDataEncodingResult) in
            switch responseResult {
            case .success(let upload, _, _):
                upload.responseObject(completionHandler: { (response: DataResponse<T>) in
                    self.resultHandler(response: response, result: result)
                })
            case .failure(let error):
                let errorPayload = ErrorPayload(error: error as NSError)
                result(.failure(errorPayload))
            }
        }
        
//        sharedSessionManager.upload(data, to: request.fullURL, method: request.method, headers: request.headers).responseObject {[weak self ] (response: DataResponse<T>) in
//            guard let self = self else { return }
//            self.resultHandler(response: response, result: result)
//        }
    }
    
    private func resultHandler<T: Model>(response: DataResponse<T>, result: @escaping APIResultHandler<T>) {
        switch response.result {
        case .success(let model):
            Logger.response(model.toJSONString() ?? "Json is empty")
            result(.success(model))
        case.failure(let error):
            let errorPayload = self.handelErrorPayload(error, response: response)
            result(.failure(errorPayload))
        }
    }
    
    private func handelErrorPayload<T: Model>(_ error: Error, response: DataResponse<T>? ) -> ErrorPayload{
        if response != nil {
            if let decodedPayload = String(data: (response?.data)!, encoding: .utf8) {
                if !decodedPayload.isEmpty {
                    if let errorPayload = ErrorPayload(JSONString: decodedPayload) {
                        Logger.error(errorPayload)
                        return errorPayload
                    }
                }
            }
        }
        let errorPayload = ErrorPayload(error: error as NSError)
        
        return errorPayload
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
