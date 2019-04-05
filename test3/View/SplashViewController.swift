//
//  SplashViewController.swift
//  test2
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tokenItem = KeychainTokenItem(service: KeychainConfiguration.tokenService, account: KeychainConfiguration.account)
        if let _ = try? tokenItem.readToken() {
            AppDelegate.shared.rootViewController.showAccountScreen()
        } else {
            AppDelegate.shared.rootViewController.showWelcomeScreen()
        }
    }
}
