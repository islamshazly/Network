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
    
    
    func getprofile() {
        
        startRequest(request: userRequest, mappingClass: self, with: { (model) in
            print(model)
        }) { (error) in
            print(error)
        }
    }
    
    func getProfileResult() {
        
        startRequest(request: userRequest, mappingClass: self) { result in
            switch result {
            case .success(let model):
                break
            case .failure(let error):
                break
            }
        }
    }
}
