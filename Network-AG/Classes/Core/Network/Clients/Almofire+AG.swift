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
        self.responseJSON { (response: DataResponse<Any>) in
            let dataResponse: DataResponse<T>
            if let error = response.result.error {
                self.logError(error)
                dataResponse = DataResponse<T>(request: self.request, response: response.response, data: response.data, result: .failure(error))
            } else {
                do {
                    self.logResponse(response)
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
        
        let invalidJson = "Not a valid JSON"
        do {
            if let jsonData = try JSONSerialization.data(withJSONObject: response.result.value, options: .prettyPrinted) as? Data{
                let json =  String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
                XCGLogger.default.debug(json)
                XCGLogger.default.debug("======= RESPONSE END =======" + "\n")
            }
        } catch {
            XCGLogger.default.debug("======= Error whilte convertirng json =======")
            XCGLogger.default.debug(response)
            XCGLogger.default.debug("======= RESPONSE END =======" + "\n")
        }
        
    }
    
    func logError(_ error: Error) {
        XCGLogger.default.debug("======= Error =======")
        XCGLogger.default.debug(error)
        XCGLogger.default.debug("======= Error END =======" + "\n")
    }
}

extension SessionManager {
    
    func request(_ request: Network_AG.Request) -> DataRequest {
        let dataRequest = Alamofire.request(request.path, method: request.method,
                                            parameters: request.parameters,
                                            encoding: request.parameterEncoding,
                                            headers: request.headers)
        
        XCGLogger.default.debug(dataRequest.debugDescription)
        
        return dataRequest
    }
}
