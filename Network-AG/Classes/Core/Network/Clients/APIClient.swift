//
//  Client.swift
//  Doobo Test
//
//  Created by Islam Elshazly on 9/18/18.
//  Copyright © 2018 Islam Elshazly. All rights reserved.
//

import Foundation
import Alamofire
import XCGLogger
import ObjectMapper
import AlamofireObjectMapper
import RxAlamofire
import RxSwift
import RxAlamofire_ObjectMapper

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
    func start<T: Model>(request: Request) -> Observable<T>
    func upload<T: Model>(data: Data, request: ImageRequest, result: @escaping APIResultHandler<T>)
    func cancelRequests()
}

extension APIClient {
    
    public func start<T>(request: Request, result: @escaping APIResultHandler<T>) where T: Model {
        
        Logger.request(request)
        Logger.debug(fullURL(fromRequest: request))
        Logger.debug(headers(fromRequest: request))
        self.lastRequest = request
        sharedSessionManager.request(self.fullURL(fromRequest: request), method: request.method, parameters: request.parameters, encoding: request.parameterEncoding, headers: self.headers(fromRequest: request)).validate(statusCode: self.validStatusCodes)
            .responseObject { [weak self] (response: DataResponse<T>) in
                guard let self = self else { return }
                self.resultHandler(response: response, result: result)
        }
    }
    
    public func start<T>(request: Request) -> Observable<T> where T: Model {
        Logger.debug(fullURL(fromRequest: request))
        Logger.request(request)
        let manager = SessionManager.default
        return manager.rx.request(request.method, self.fullURL(fromRequest: request), parameters: request.parameters, encoding: request.parameterEncoding, headers: self.headers(fromRequest: request)).validate(statusCode: self.validStatusCodes)
            .responseMappable(as: T.self)
            .flatMapLatest { (model) -> Observable<T> in
                Logger.debug(model.toJSON())
                return Observable.just(model)
                    .catchError { error in
                        Logger.error(error)
                        guard let payload = ErrorPayload(error: error as NSError) as? ErrorPayload else {
                            return Observable.error(ErrorPayload(message: error.localizedDescription))
                        }
                        return Observable.error(payload)}}
            .catchError { error in
                Logger.error(error)
                guard let payload = ErrorPayload(error: error as NSError) as? ErrorPayload else {
                    return Observable.error(ErrorPayload(message: error.localizedDescription))
                }
                return Observable.error(payload)
        }
    }
    
    public func upload<T>(data: Data, request: ImageRequest, result: @escaping APIResultHandler<T>) where T: Model {
        Logger.request(request)
        Logger.debug(fullURL(fromRequest: request))
        Logger.debug(headers(fromRequest: request))
        
        guard let imageName = request.imageName, let imageFileName = request.imageFileName else {
            return
        }
        
        sharedSessionManager.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(data, withName: imageName, fileName: imageFileName, mimeType: "image/*")
            for (key, value) in request.parameters! {
                if let stringValue = value as? String {
                    multipartFormData.append(stringValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, to:fullURL(fromRequest: request), method: request.method, headers: headers(fromRequest: request))
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
    
    private func handelErrorPayload<T: Model>(_ error: Error, response: DataResponse<T>? ) -> ErrorPayload {
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
    
    
    
    
    
    public func cancelRequests() {
        let session = Alamofire.SessionManager.default
        session.session.getTasksWithCompletionHandler { dataTasks, _ , _  in
            dataTasks.forEach { $0.cancel() }
        }
        Logger.debug("======= CANCEL REQUESTS =======")
    }
    
    // MARK: - Private functions
    
    /// Combines default headers with request headers.
    /// Prefers request headers in case of key duplication.
    private func headers(fromRequest request: Request) -> [String: String] {
        guard let requestHeaders = request.headers else {
            return defaultHeaders
        }
        
        return requestHeaders.merging(defaultHeaders, uniquingKeysWith: { (requestHeaders, _) in requestHeaders })
    }
    
    private func fullURL(fromRequest request: Request) -> URL {
        
        if request.baseURL != nil {
            return URL(string: request.fullURL!)!
        } else if !baseUrl.isEmpty {
            
            let url = baseUrl + request.path
            return URL(string: url)!
        } else {
            fatalError("You should provide the base url")
        }
    }
}
