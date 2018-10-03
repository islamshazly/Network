//
//  APILogger.swift
//  Network+AG
//
//  Created by Islam Elshazly on 10/3/18.
//
import XCGLogger

public protocol APILogger: class {

    func logger(_ any: Any)
}

public extension APILogger {
    
    public func logger(_ any: Any) {
        let log = XCGLogger.default
        log.debug(any)
    }
}
