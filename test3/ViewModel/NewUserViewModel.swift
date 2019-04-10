//
//  NewUserViewModel.swift
//  test3
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

class NewUserViewModel: Validatable {
    
    internal var brokenRules = [BrokenRule]()
    
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
}
