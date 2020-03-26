//
//  ViewController.swift
//  Network-AG
//
//  Created by islamshazly on 09/27/2018.
//  Copyright (c) 2018 islamshazly. All rights reserved.
//

import UIKit
import Network_IS
import XCGLogger
import RxSwift

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callRequest()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    func callRequest() {
        DooboClient.shared.start(request: UserAPI.login) { (result: APIResult<UserMappable, ErrorPayload>) in
            
            switch result {
            case .success(let model):
                break
            case.failure(let error):
                    
                break
            }
        }
        
        let asd: Observable<UserMappable> = DooboClient.shared.start(request: UserAPI.login)
        
        _ = asd.do(onNext: { (model) in
            print(model)
            })
        
        _ = asd.subscribe(onNext: { (mdo) in
            print(mdo)
        }, onError: { (error) in
            print(error)
        })
    }
}

