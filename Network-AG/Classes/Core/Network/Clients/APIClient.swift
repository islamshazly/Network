//
//  Client.swift
//  Doobo Test
//
//  Created by Islam Elshazly on 9/18/18.
//  Copyright © 2018 Islam Elshazly. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RxSwift

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

        self.lastRequest = request
        sharedSessionManager.request(self.fullURL(fromRequest: request), method: request.method, parameters: request.parameters, encoding: request.parameterEncoding, headers: self.headers(fromRequest: request)).validate(statusCode: self.validStatusCodes)
            .responseObject { [weak self] (response: DataResponse<T>) in
                guard let self = self else { return }
                self.resultHandler(response: response, result: result)
        }
    }
    
    public func start<T>(request: Request) -> Observable<T> where T: Model {
        
        return Observable.create({ [unowned self] observable  in
            
            self.sharedSessionManager.request(self.fullURL(fromRequest: request), method: request.method, parameters: request.parameters, encoding: request.parameterEncoding, headers: self.headers(fromRequest: request)).validate(statusCode: self.validStatusCodes)
        .responseObject { [weak self] (response: DataResponse<T>) in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let model):
                observable.onNext(model)
            case.failure(let error):
                let errorPayload = self.handelErrorPayload(error, response: response)
                observable.onError(errorPayload)
            }}
            
            return Disposables.create {}
        })
    }
    
    public func upload<T>(data: Data, request: ImageRequest, result: @escaping APIResultHandler<T>) where T: Model {
        
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

extension DataRequest {
    //Overriding several methods from Alamofire Validation
    
    @discardableResult
    public func validate<S: Sequence>(statusCode acceptableStatusCodes: S) -> Self where S.Iterator.Element == Int {
        return self.validate { [unowned self] _, response, bodyData  in
            return self.validate(statusCode: acceptableStatusCodes, response: response, bodyData: bodyData)
        }
    }

    //Overriding several methods from Alamofire Validataion
    func validate<S: Sequence>(
        statusCode acceptableStatusCodes: S,
        response: HTTPURLResponse, bodyData: Data?)
        -> ValidationResult
        where S.Iterator.Element == Int
    {
        if acceptableStatusCodes.contains(response.statusCode) {
            return .success
        } else {
            var error: Error = AFError.responseValidationFailed(reason: AFError.ResponseValidationFailureReason.unacceptableStatusCode(code: response.statusCode))
            if let bodyData = bodyData {
                if let jsonString = String(data: bodyData, encoding: .utf8) {
                    if let errorNew = Mapper<ErrorPayload>().map(JSONString: jsonString)
                    {
                        error = errorNew
                    }
                }
            }
            return .failure(error)
        }
    }
}
