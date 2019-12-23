//
//  Logger.swift
//  Network+AG
//
//  Created by Islam Elshazly on 10/3/18.
//

import XCGLogger
import Alamofire
import ObjectMapper

final public class Logger {
    
    // To Expose all XCGLogger properties and methods
    
    static let Debug = XCGLogger.default
    
    init(debug level: XCGLogger.Level = .debug) {
        Logger.Debug.setup(level: level, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLevel: level)
        XCGLogger.default.logAppDetails()
    }
    
    public static func debug(_ any: Any) {
        Debug.debug(any)
    }
    
    public static func response(_ response: Data) {
        Debug.debug("======= RESPONSE =======")
        
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response ?? [:] , options: .prettyPrinted)
            let json =  String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
            Debug.debug(json)
            Debug.debug("======= RESPONSE END =======" + "\n")
        } catch {
            Debug.debug("======= Error whilte convertirng json =======")
            Debug.debug(response)
            Debug.debug("======= RESPONSE END =======" + "\n")
        }
        
    }
    
    public static func response(_ json: String) {
        Debug.debug("======= RESPONSE =======")
        Debug.debug(json)
        Debug.debug("======= RESPONSE END =======" + "\n")
        
    }
    
    public static func error(_ error: Error) {
        Debug.debug("======= Error =======")
        Debug.debug(error)
        Debug.debug("======= Error END =======" + "\n")
    }
    
    public static func error(_ error: ErrorPayload) {
        Debug.debug("======= Error =======")
        Debug.debug(error.statusCode)
        Debug.debug(error.statusMessage)
        Debug.debug("======= Error END =======" + "\n")
    }
    
    public static func request(_ request: Request) {
        Debug.debug("======= REQUEST START =======")
        Debug.debug("= PARAMTERS: " + String(describing: request.parameters))
        Debug.debug("= HEADERS: " + String(describing: request.headers))
        Debug.debug("= HTTPMETHOD: " + String(describing: request.method))
        Debug.debug("======== REQUEST END =========" + "\n")
    }
}
