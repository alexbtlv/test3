//
//  NewUserViewModel.swift
//  test3
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import MBProgressHUD

class NewUserViewModel: Validatable {
    
    internal var brokenRules = [BrokenRule]()
    internal unowned let view: SignUpViewController
    
    var newPassword = Dynamic<String>("")
    var confirmPassword = Dynamic<String>("")
    var name = Dynamic<String>("")
    var email = Dynamic<String>("")
    
    var hasValidName: Bool {
        if let n = name.value, n.isEmpty {
            return false
        }
        return true
    }
    
    var hasValidEmail: Bool {
        if let e = email.value, e.isValidEmail {
            return true
        }
        return false
    }
    
    var passwordsAreMatching: Bool {
        if let newPass = newPassword.value, let confirmPass = confirmPassword.value, newPass == confirmPass && !newPass.isEmpty {
            return true
        }
        return false
    }
    
    var validationMessage: String {
        get {
            var message = ""
            for brokenRule in brokenRules {
                message += brokenRule.message + "\n"
            }
            return message
        }
    }
    
    var isValid: Bool {
        get {
            brokenRules = []
            validate()
            return brokenRules.count == 0 ? true : false
        }
    }
    
    init(viewController: SignUpViewController) {
        self.view = viewController
    }
    
    private func validate() {
        if !hasValidName {
            self.brokenRules.append(BrokenRule(propertyName: "name", message: "Name can not be empty"))
        }
        
        if  !hasValidEmail {
            self.brokenRules.append(BrokenRule(propertyName: "email", message: "Please enter valid email"))
        }
        
        if !passwordsAreMatching {
            self.brokenRules.append(BrokenRule(propertyName: "confirmPassword", message: "Passwords are not matching"))
        }
    }
    
    func performSignUpRequest()  {
        guard let username = name.value, let email = email.value, let password = newPassword.value else {
            preconditionFailure("Make sure to validate user inputs.")
        }
        
        MBProgressHUD.showAdded(to: view.view, animated: true)
        let futureUser = NetworkingManager.registerUser(username: username, email: email, password: password)
        futureUser.execute(completion: { [weak self] result in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.view.view, animated: true)
            switch result {
            case .failure(let errorMessage):
                self.view.showAlert(withMessage: errorMessage.localizedDescription)
            case .success(let tokenID):
                do {
                    let tokenItem = KeychainTokenItem(service: KeychainConfiguration.tokenService, account: KeychainConfiguration.account)
                    try tokenItem.saveToken(tokenID.token)
                    AppDelegate.shared.rootViewController.showAccountScreen()
                } catch {
                    self.view.showAlert(withMessage: error.localizedDescription)
                }
            }
        })
    }
}
