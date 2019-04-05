//
//  WelcomeViewController.swift
//  test3
//
//  Created by Alexander Batalov on 4/4/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Hey!"
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
    }
}
