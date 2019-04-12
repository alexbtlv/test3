//
//  PotentialUserViewModel.swift
//  test3
//
//  Created by Alexander Batalov on 4/6/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation
import MBProgressHUD


class PotentialUserViewModel: Validatable {
    
    internal unowned let view: LogInViewController
    
    var password = Dynamic<String>("")
    var email = Dynamic<String>("")
    var brokenRules = [BrokenRule]()
    var isValid: Bool {
        get {
            brokenRules = []
            validate()
            return brokenRules.count == 0 ? true : false
        }
    }
    var hasValidEmail: Bool {
        if let e = email.value, e.isValidEmail {
            return true
        }
        return false
    }
    var hasPassword: Bool {
        if let pass = password.value, !pass.isEmpty {
            return true
        }
        return false
    }
    var validationMessage: String {
        get {
            var message = ""
            for brokenRule in brokenRules {
                message += brokenRule.message
                message += "\n"
            }
            return message
        }
    }
    
    init(viewController: LogInViewController) {
        self.view = viewController
    }
    
    private func validate() {
        if !hasValidEmail {
            self.brokenRules.append(BrokenRule(propertyName: "email", message: "Please enter valid email"))
        }
        
        if !hasPassword {
            self.brokenRules.append(BrokenRule(propertyName: "password", message: "Password can not be empty"))
        }
    }
    
    func performSignInRequest() {
        guard let email = email.value, let password = password.value else {
            preconditionFailure("Make sure to validate user inputs.")
        }
        
        MBProgressHUD.showAdded(to: view.view, animated: true)
        let signInFuture = NetworkingManager.signInUser(email: email, password: password)
        signInFuture.execute(completion: { [weak self] result in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.view.view, animated: true)
            switch result {
            case .success(let tokenID):
                do {
                    let tokenItem = KeychainTokenItem(service: KeychainConfiguration.tokenService, account: KeychainConfiguration.account)
                    try tokenItem.saveToken(tokenID.token)
                    AppDelegate.shared.rootViewController.showAccountScreen()
                } catch {
                    self.view.showAlert(withMessage: error.localizedDescription)
                }
            case .failure(let error):
                self.view.showAlert(withMessage: error.localizedDescription)
            }
        })
    }
}
