//
//  ErrorPayload.swift
//  Network+AG
//
//  Created by Islam Elshazly on 11/5/18.
//

import Foundation
import ObjectMapper

public class ErrorPayload: Model, Error {
    
    // MARK: - Properties
    
    private var code: Int = 0
    public var message: String = ""
    public var businessCode: String = ""
    public var status: Int = 0
    
    public var statusCode: Int {
        set {
            code = newValue
        }
        
        get {
            return code
        }
    }
    
    public var statusMessage: String {
        set {
            message = newValue
        }
        
        get {
            return message
        }
    }
    
    public init(error: NSError) {
        code = error.code
        message = error.localizedDescription
        
    }
    
    public init(message: String) {
        code = 100
        self.message = message
    }
    
    // MARK: - Initialization Methods
    
    public required init?(map: Map) {
    }
    
    public init() {
    }
    
    //
    public func mapping(map: Map) {
        code <- map["code"]
        businessCode <- map["code"]
        status <- map["error.status"]
        message <- map["data.message"]
        if message == "" {
            message <- map["error.message"]
        }
        if message == "" {
        message <- map["message"]
        }
    }
    
    func generateError(description: String) -> NSError {
        let userInfo: [String : Any] = [
            NSLocalizedDescriptionKey: description,
            NSLocalizedFailureReasonErrorKey: description
        ]
        let error = NSError(domain: description, code: 1000, userInfo: userInfo)
        return error
    }
}
