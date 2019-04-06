//
//  LogInViewController.swift
//  test3
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import MBProgressHUD

class LogInViewController: UIViewController {

    @IBOutlet private weak var emailTextField: BindingHoshiTextField!
    @IBOutlet private weak var passwordTextField: BindingHoshiTextField!
    
    private var user = PotentialUserViewModel()
    private let sessionManager = UserSessionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func logInButtonTapped(_ sender: Any) {
        if user.isValid {
            MBProgressHUD.showAdded(to: view, animated: true)
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                
                self.sessionManager.signInUser(user: self.user, completion: { result in
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        switch result {
                        case .success:
                            AppDelegate.shared.rootViewController.showAccountScreen()
                        case .failure(let error):
                            self.showAlert(withMessage: error)
                        }
                    } // end of main async
                })
            }
        } else {
            showAlert(withMessage: user.validationMessage)
        }
    }
    
    private func setupUI() {
        emailTextField.bind { [unowned self] in
            self.user.email.value = $0
        }
        
        passwordTextField.bind { [unowned self] in
            self.user.password.value = $0
        }
    }
}
