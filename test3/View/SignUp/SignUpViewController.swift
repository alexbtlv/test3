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
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private let newUser = NewUserViewModel()
    private let registrationService = UserRegistrationManager()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
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
        
        // Register For Keyboard Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction private func signUpButtonTapped(_ sender: Any) {
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
                            AppDelegate.shared.rootViewController.showAccountScreen()
                        }
        
                    }
                })
            }
        } else {
            showAlert(withMessage: newUser.validationMessage)
        }
    }
    
    @objc private func onKeyboardAppear(_ notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

}
