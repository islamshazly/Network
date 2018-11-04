//
//  ViewController.swift
//  Network-AG
//
//  Created by islamshazly on 09/27/2018.
//  Copyright (c) 2018 islamshazly. All rights reserved.
//

import UIKit
import Network_AG
import XCGLogger

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callRequest()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    func callRequest() {
        DooboClient.shared.start(request: UserAPI.logout) { (result: APIResult<userMappable, Error>) in
            
            switch result {
            case .success(let model):
                break
            case.failure(let error):
                break
            }
        }
    }
}

