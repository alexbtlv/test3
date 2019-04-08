//
//  PotentialUserViewModel.swift
//  test3
//
//  Created by Alexander Batalov on 4/6/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation


class PotentialUserViewModel: Validatable {
    
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
    
    private func validate() {
        if !hasValidEmail {
            self.brokenRules.append(BrokenRule(propertyName: "email", message: "Please enter valid email"))
        }
        
        if !hasPassword {
            self.brokenRules.append(BrokenRule(propertyName: "password", message: "Password can not be empty"))
        }
    }
}
