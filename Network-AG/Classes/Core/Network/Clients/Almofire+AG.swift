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
        self.responseJSON { [ weak self ] (response: DataResponse<Any>) in
            guard let self = self else { return }
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
    
    private func logResponse(_ response: DataResponse<Any>) {
        logger("======= RESPONSE =======")
        
        let invalidJson = "Not a valid JSON"
        do {
            if let jsonData = try JSONSerialization.data(withJSONObject: response.result.value, options: .prettyPrinted) as? Data{
                let json =  String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
                logger(json)
                logger("======= RESPONSE END =======" + "\n")
            }
        } catch {
            logger("======= Error whilte convertirng json =======")
            logger(response)
            logger("======= RESPONSE END =======" + "\n")
        }
        
    }
    
    private func logError(_ error: Error) {
        logger("======= Error =======")
        logger(error)
        logger("======= Error END =======" + "\n")
    }
}

extension SessionManager {
    
    func request(_ request: Network_AG.Request) -> DataRequest {
        let dataRequest = Alamofire.request(request.path, method: request.method,
                                            parameters: request.parameters,
                                            encoding: request.parameterEncoding,
                                            headers: request.headers)
        
        logger(dataRequest.debugDescription)
        
        return dataRequest
    }
}
