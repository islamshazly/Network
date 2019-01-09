//
//  user.swift
//  Network-AG_Example
//
//  Created by Islam Elshazly on 9/27/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Network_IS
import XCGLogger
import  ObjectMapper

class UserDecodable: Decodable {
    
    var refreshInterval: Double = 0
    var userRequest: UserAPI = .login
    
    enum UserKeys: String, CodingKey {
        case refreshInterval = "RefreshInterval"
    }

    init() {
        userRequest = .login
    }
    
    init(refreshInterval: Double) {
        self.refreshInterval = refreshInterval
    }
    
    required convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: UserKeys.self) // defining our (keyed) container
        let refresh: Double = try container.decode(Double.self, forKey: .refreshInterval) // extracting the data
        
        self.init(refreshInterval: refresh)
    }
    
    func getProfileResult() {
        
        
    }
    
}

class userMappable: Model {
    
    var refreshInterval: Double?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        refreshInterval <- map["RefreshInterval"]
    }
}
