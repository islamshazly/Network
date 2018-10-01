//
//  user.swift
//  Network-AG_Example
//
//  Created by Islam Elshazly on 9/27/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper
import Network_AG

class UserDecodable: Decodable, FunctionalClient {
    
    var carID: Double = 0
    var userRequest: UserAPI = .login
    var request: APIRequest?
    
    enum UserKeys: String, CodingKey {
        case name = "RefreshInterval"
    }

    init() {
        
    }
    
    init(name: Double) {
        self.carID = name
    }
    
    required convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: UserKeys.self) // defining our (keyed) container
        let fullName: Double = try container.decode(Double.self, forKey: .name) // extracting the data
        
        self.init(name: fullName)
    }
    
    
    func getProfileResult() {
        
        startRequest(request: userRequest, mappingClass: self) { result in
            switch result {
            case .success(let model):
                let asd = model as! UserDecodable
                log.debug(asd.carID)
                break
            case .failure( _):
                break
            }
        }
    }
}

class User: Mappable {
    
    var name: String = ""
    var userRequest: UserAPI = .login
    var request: APIRequest?
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        
    }
}

extension User: FunctionalClient {
    
    func getProfileResult() {
        
//        startRequest(request: userRequest, mappingClass: self) { result in
//            switch result {
//            case .success( _):
//                break
//            case .failure( _):
//                break
//            }
        }
    }

