//
//  SignUpViewController.swift
//  test3
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import MBProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet private weak var nameTextField: BindingHoshiTextField!
    @IBOutlet private weak var emailTextField: BindingHoshiTextField!
    @IBOutlet private weak var passwordTextField: BindingHoshiTextField!
    @IBOutlet private weak var repeatPasswordTextField: BindingHoshiTextField!
    
    var newUser = NewUserViewModel()
    let registrationService = UserRegistrationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        nameTextField.bind { [unowned self] in
            self.newUser.name.value = $0
        }
        
        emailTextField.bind { [unowned self] in
            self.newUser.email.value = $0
        }
        
        passwordTextField.bind { [unowned self] in
            self.newUser.newPassword.value = $0
        }
        
        repeatPasswordTextField.bind { [unowned self] in
            self.newUser.confirmPassword.value = $0
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        if newUser.isValid {
            MBProgressHUD.showAdded(to: view, animated: true)
            
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                
                self.registrationService.registerUser(user: self.newUser, completion: { result in
                    DispatchQueue.main.async {
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        switch result {
                        case .failure(let errorMessage):
                                self.showAlert(withMessage: errorMessage)
                        case .success:
                            // proceed to the account
                        }
                        
                    }
                })
            }
        } else {
            showAlert(withMessage: newUser.validationMessage)
        }
    }
    

}
