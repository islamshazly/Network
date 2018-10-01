//
//  ViewController.swift
//  Network-AG
//
//  Created by islamshazly on 09/27/2018.
//  Copyright (c) 2018 islamshazly. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let user = User()
        user.getProfileResult()
//        user.getProfile()
        
        let userDecode = UserDecodable()
        userDecode.getProfileResult()
    }
    
}

