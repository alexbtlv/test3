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
    private let sessionManager = UserSessionManager()
    
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
        }
        
        passwordTextField.bind { [unowned self] in
            self.user.password.value = $0
        }
        
        // Register For Keyboard Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction private func logInButtonTapped(_ sender: Any) {
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
