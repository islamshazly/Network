//
//  ImageRequest.swift
//  Network+IS
//
//  Created by Islam Elshazly on 1/9/19.
//

import Foundation

public protocol ImageRequest: Request {
    
    var imageName: String? { get }
    var imageFileName: String? { get }
}
