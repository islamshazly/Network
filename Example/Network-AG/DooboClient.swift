//
//  DooboClient.swift
//  Network_Example
//
//  Created by Islam Elshazly on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Network_AG
import Alamofire

final class DooboCLient: APIClient {

    var sharedSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15.0

        let sessionManager: SessionManager = SessionManager(configuration: configuration)
        
        return sessionManager
    }()
    
    var baseUrl: String = ""
    
    var defaultHeaders: [String : String] = [:]
    
    static let shared: DooboCLient = DooboCLient()
    
    
}

