//
//  Logger.swift
//  Network+AG
//
//  Created by Islam Elshazly on 10/3/18.
//

import XCGLogger
import Alamofire
import ObjectMapper

final class Logger {
    
    // To Expose all XCGLogger properties and methods
    
    static let Debug = XCGLogger.default
    
    init(debug level: XCGLogger.Level = .debug) {
        Logger.Debug.setup(level: level, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLevel: level)
        XCGLogger.default.logAppDetails()
    }
    
    static func debug(_ any: Any) {
        Logger.Debug.debug(any)
    }
    
    static func response(_ response: DataResponse<Any>) {
        Logger.Debug.debug("======= RESPONSE =======")
        
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response.result.value ?? [:] , options: .prettyPrinted)
                let json =  String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
                Logger.Debug.debug(json)
                Logger.Debug.debug("======= RESPONSE END =======" + "\n")
        } catch {
            Logger.Debug.debug("======= Error whilte convertirng json =======")
            Logger.Debug.debug(response)
            Logger.Debug.debug("======= RESPONSE END =======" + "\n")
        }
        
    }
    
    static func response(_ json: String) {
        Logger.Debug.debug("======= RESPONSE =======")
        Logger.Debug.debug(json)
        Logger.Debug.debug("======= RESPONSE END =======" + "\n")

    }
    
    static func error(_ error: Error) {
        Logger.Debug.debug("======= Error =======")
        Logger.Debug.debug(error)
        Logger.Debug.debug("======= Error END =======" + "\n")
    }
    
    static func request(_ request: Request) {
        Logger.Debug.debug("======= REQUEST START =======")
        Logger.Debug.debug("= URL " + request.fullURL)
        Logger.Debug.debug("= PARAMTERS " + String(describing: request.parameters))
        Logger.Debug.debug("= HEADERS " + String(describing: request.headers))
        Logger.Debug.debug("= HTTPMETHOD " + String(describing: request.method))
        Logger.Debug.debug("======== REQUEST END =========" + "\n")
    }
    
}
