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
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private var user = PotentialUserViewModel()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        emailTextField.bind { [unowned self] in
            self.user.email.value = $0
            if self.user.hasValidEmail {
                self.emailTextField.borderActiveColor = Constants.pwGreenColor
                self.emailTextField.borderInactiveColor = Constants.pwGreenColor
            } else {
                self.emailTextField.borderActiveColor = Constants.pwOrangeColor
                self.emailTextField.borderInactiveColor = Constants.pwOrangeColor
            }
        }
        
        passwordTextField.bind { [unowned self] in
            self.user.password.value = $0
            if self.user.hasPassword {
                self.passwordTextField.borderActiveColor = Constants.pwGreenColor
                self.passwordTextField.borderInactiveColor = Constants.pwGreenColor
            } else {
                self.passwordTextField.borderActiveColor = Constants.pwOrangeColor
                self.passwordTextField.borderInactiveColor = Constants.pwOrangeColor
            }
        }
        
        // Register For Keyboard Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction private func logInButtonTapped(_ sender: Any) {
        if user.isValid {
            MBProgressHUD.showAdded(to: view, animated: true)
            let signInFuture = NetworkingManager.signInUser(email: self.user.email.value!, password: self.user.password.value!)
            signInFuture.execute(completion: { [weak self] result in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch result {
                case .success(let tokenID):
                    do {
                        let tokenItem = KeychainTokenItem(service: KeychainConfiguration.tokenService, account: KeychainConfiguration.account)
                        try tokenItem.saveToken(tokenID.token)
                        AppDelegate.shared.rootViewController.showAccountScreen()
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        } else {
            showAlert(withMessage: user.validationMessage)
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
