//
//  Almofire+AG.swift
//  Alamofire
//
//  Created by Islam Elshazly on 10/1/18.
//

import Alamofire

extension Alamofire.DataRequest {
    
    func responseObject<T: Decodable>(completionHandler: @escaping (DataResponse<T>) -> Void) {
        self.responseJSON { (response: DataResponse<Any>) in
            let dataResponse: DataResponse<T>
            if let error = response.result.error {
                dataResponse = DataResponse<T>(request: self.request, response: response.response, data: response.data, result: .failure(error))
            } else {
                do {
                    let decoder = JSONDecoder()
                    let responseObject: T = try! decoder.decode(T.self, from: response.data!)
                    dataResponse = DataResponse<T>(request: self.request, response: response.response, data: response.data, result: .success(responseObject))
                } catch let error  {
                    dataResponse = DataResponse<T>(request: self.request, response: response.response, data: response.data, result: .failure(error))
                }
            }
            
            completionHandler(dataResponse)
        }
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
