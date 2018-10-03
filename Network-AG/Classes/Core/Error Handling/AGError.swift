//
//  DooboError.swift
//  Doobo Test
//
//  Created by Islam Elshazly on 9/23/18.
//  Copyright © 2018 Areeb Group. All rights reserved.
//

import Foundation

public enum AGError: Error {
    
    case unknown
    case authorization
    case noConnection
    case timeout
    
}

extension AGError {
    
    var localizedDescription: String {
        
        switch self {
        case .unknown:
            return ""
        default:
            return ""
        }
    }
}
