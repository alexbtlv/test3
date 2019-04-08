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
    
    @IBAction private func logInButtonTapped(_ sender: Any) {
        let loginVC = LogInViewController(nibName: "LogInViewController", bundle: nil)
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction private func signUpButtonTapped(_ sender: Any) {
        let signUPVC = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        navigationController?.pushViewController(signUPVC, animated: true)
    }
}
