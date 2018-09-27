//
//  Request.swift
//  Doobo Test
//
//  Created by Islam Elshazly on 9/17/18.
//  Copyright © 2018 Areeb Group. All rights reserved.
//

import Foundation
import Alamofire

public protocol APIRequest {
    
    var shouldRetry: Bool {get}
    var baseURL: URL {get}
    var path: String {get}
    var method: Alamofire.HTTPMethod {get}
    var parameterEncoding: ParameterEncoding {get}
    var headers: [String : String]? {get}
    var parameters: [String: Any]?  {get}
    
}

