//
//  ViewController.swift
//  Network-AG
//
//  Created by islamshazly on 09/27/2018.
//  Copyright (c) 2018 islamshazly. All rights reserved.
//

import UIKit
import Network_AG

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDecode = UserDecodable()
        userDecode.getProfileResult()
        
        DooboCLient.shared.start(request: UserAPI.login) { (result: APIResult<UserDecodable, Error>) in
            
            switch result {
            case .success(let model):
                print(model.refreshInterval)
            case.failure(let error):
                print(error)
            }
        }
        
    }
}

