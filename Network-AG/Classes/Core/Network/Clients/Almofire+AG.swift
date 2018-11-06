//
//  Almofire+AG.swift
//  Alamofire
//
//  Created by Islam Elshazly on 10/1/18.
//

import Alamofire
import ObjectMapper

extension Alamofire.DataRequest{
    
    func responseObjectDecodable<T: Decodable>(completionHandler: @escaping (DataResponse<T>) -> Void) {
        self.responseJSON {(response: DataResponse<Any>) in
            let dataResponse: DataResponse<T>
            if let error = response.result.error {
                Logger.error(error)
                dataResponse = DataResponse<T>(request: self.request, response: response.response, data: response.data, result: .failure(error))
            } else {
                do {
                    Logger.response(response)
                    let decoder = JSONDecoder()
                    let responseObject: T = try decoder.decode(T.self, from: response.data!)
                    dataResponse = DataResponse<T>(request: self.request, response: response.response, data: response.data, result: .success(responseObject))
                } catch let error  {
                    Logger.error(error)
                    dataResponse = DataResponse<T>(request: self.request, response: response.response, data: response.data, result: .failure(error))
                }
            }
            completionHandler(dataResponse)
        }
    }
}

extension SessionManager {
    
    func request(_ request: Network_AG.Request) -> DataRequest {
        let dataRequest = Alamofire.request(request.fullURL, method: request.method,
                                            parameters: request.parameters,
                                            encoding: request.parameterEncoding,
                                            headers: request.headers)
        Logger.debug(dataRequest.debugDescription)
        
        return dataRequest
    }
}

extension RequestRetrier {
    
    func retryRequest(seesion: SessionManager, request: Network_AG.Request, retrying error: Error, requestRetryCompletion: @escaping RequestRetryCompletion) {
        let almofireRequest = Alamofire.request(request.fullURL, method: request.method,
                                        parameters: request.parameters,
                                        encoding: request.parameterEncoding,
                                        headers: request.headers)
        Alamofire.SessionManager.default.retrier?.should(seesion, retry: almofireRequest, with: error, completion: { (bool, timeInterval) in
            requestRetryCompletion(bool,timeInterval)
        })
        
    }
}
