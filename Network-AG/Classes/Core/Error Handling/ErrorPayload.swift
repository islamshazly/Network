//
//  ErrorPayload.swift
//  Network+AG
//
//  Created by Islam Elshazly on 11/5/18.
//

import Foundation
import ObjectMapper

public class ErrorPayload: Model, Error {
    
    var code: Int = 0
    var message: String = ""
    
    
    public required init?(map: Map) {
    }
    
    public init() {
    }
    
    public func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
    }
    
    
    
}
