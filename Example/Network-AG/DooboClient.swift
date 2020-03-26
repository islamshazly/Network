//
//  DooboClient.swift
//  Network_Example
//
//  Created by Islam Elshazly on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Network_IS
import Alamofire
import ObjectMapper

final class DooboClient: APIClient {

    var validStatusCodes: ClosedRange<Int> {
        return 200...300
    }
    static let shared: DooboClient = DooboClient()
    var lastRequest: Network_IS.Request?
    var sharedSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        return SessionManager(configuration: configuration)
    }()
    
    var baseUrl: String = "http://95.177.166.89/api/"
    var defaultHeaders: [String : String] = [:]
    
}

