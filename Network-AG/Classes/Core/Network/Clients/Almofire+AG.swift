//
//  Almofire+AG.swift
//  Alamofire
//
//  Created by Islam Elshazly on 10/1/18.
//

import Alamofire
import XCGLogger

extension Alamofire.DataRequest {
    
    
    func responseObject<T: Decodable>(completionHandler: @escaping (DataResponse<T>) -> Void) {
        self.responseJSON { [weak self] (response: DataResponse<Any>) in
            guard let self = self else { return }
            self.logResponse(response)
            let dataResponse: DataResponse<T>
            if let error = response.result.error {
                self.logError(error)
                dataResponse = DataResponse<T>(request: self.request, response: response.response, data: response.data, result: .failure(error))
            } else {
                do {
                    let decoder = JSONDecoder()
                    let responseObject: T = try! decoder.decode(T.self, from: response.data!)
                    dataResponse = DataResponse<T>(request: self.request, response: response.response, data: response.data, result: .success(responseObject))
                } catch let error  {
                    self.logError(error)
                    dataResponse = DataResponse<T>(request: self.request, response: response.response, data: response.data, result: .failure(error))
                }
            }
            
            completionHandler(dataResponse)
        }
    }
    
    func logResponse(_ response: DataResponse<Any>) {
        XCGLogger.default.debug("======= RESPONSE =======")
        XCGLogger.default.debug(response)
        XCGLogger.default.debug("======= RESPONSE END =======" + "\n")
    }
    
    func logError(_ error: Error) {
        XCGLogger.default.debug("======= Error =======")
        XCGLogger.default.debug(error)
        XCGLogger.default.debug("======= Error END =======" + "\n")
    }
}

extension SessionManager {
    
    func requestAG<R: Network_AG.Request, T: Decodable>(_ request: R) -> DataResponse<T>? {

        Alamofire.request(request.path, method: request.method,
                          parameters: request.parameters,
                          encoding: request.parameterEncoding,
                          headers: request.headers).responseObject { (response: DataResponse<T>) in
                            return response
        }
        return nil
    }
}
