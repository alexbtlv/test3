//
//  PotentialTransactionViewModel.swift
//  test3
//
//  Created by Alexander Batalov on 4/6/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

class PotentialTransactionViewModel: Validatable {
    
    var recipient = Dynamic<String>("")
    var amount = Dynamic<Int>(0)
    var senderBalance: Int = 0
    var brokenRules = [BrokenRule]()
    var isValid: Bool {
        brokenRules = []
        validate()
        return brokenRules.count == 0 ? true : false
    }
    var validationMessage: String {
        var message = ""
        for brokenRule in brokenRules {
            message += brokenRule.message
            message += "\n"
        }
        return message
    }
    
    private func validate() {
        if let name = recipient.value, name.isEmpty {
            brokenRules.append(BrokenRule(propertyName: "name", message: "Name can not be empty"))
        }
        
        if let amount = amount.value, amount > senderBalance {
            brokenRules.append(BrokenRule(propertyName: "amount", message: "Insufficient funds. Please top up your balance."))
        }
    }
}
