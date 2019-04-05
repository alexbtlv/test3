//
//  SignUpViewController.swift
//  test3
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet private weak var nameTextField: BindingHoshiTextField!
    @IBOutlet private weak var emailTextField: BindingHoshiTextField!
    @IBOutlet private weak var passwordTextField: BindingHoshiTextField!
    @IBOutlet private weak var repeatPasswordTextField: BindingHoshiTextField!
    
    var newUser = NewUserViewModel()
    
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
            // send .post req to register new user
            
            // handle response
        } else {
            showAlert(withMessage: newUser.validationMessage)
        }
    }
    

}
