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
    private var message: String = ""
    var businessCode: String = ""
    
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
    
    // MARK: - Initialization Methods
    
    public required init?(map: Map) {
    }
    
    public init() {
    }
    
    //
    public func mapping(map: Map) {
        businessCode <- map["code"]
        message <- map["message"]
    }
}
