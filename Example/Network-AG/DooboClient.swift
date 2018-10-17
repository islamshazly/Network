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

final class DooboClient: APIClient {
    
    static let shared: DooboClient = DooboClient()
    var sharedSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataDontLoad
        return SessionManager(configuration: configuration)
    }()
    
    var baseUrl: String = ""
    
    var defaultHeaders: [String : String] = [:]
    
}

