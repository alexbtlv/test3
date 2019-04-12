//
//  PotentialTransactionViewModel.swift
//  test3
//
//  Created by Alexander Batalov on 4/6/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import MBProgressHUD

class PotentialTransactionViewModel: Validatable {
    
    internal unowned let view: CreateTransactionViewController
    
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
    
    init(view: CreateTransactionViewController) {
        self.view = view
    }
    
    private func validate() {
        if let name = recipient.value, name.isEmpty {
            brokenRules.append(BrokenRule(propertyName: "name", message: "Name can not be empty"))
        }
        
        if let amount = amount.value, amount > senderBalance || amount < 0 {
            brokenRules.append(BrokenRule(propertyName: "amount", message: "Insufficient funds. Please top up your balance."))
        }
        
        if let amount = amount.value, amount == 0 {
            brokenRules.append(BrokenRule(propertyName: "amount", message: "Please enter valid amount."))
        }
    }
    
    func getUsernamesForAutocomplete() {
        guard let query = recipient.value else { return }
        let namesFuture = NetworkingManager.getUsernames(query: query)
        namesFuture.execute { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let recipients):
                let names = recipients.map { $0.name }
                self.view.recipientTextField.filterStrings(names)
            case .failure(let errorMessage):
                self.view.showAlert(withMessage: errorMessage.localizedDescription)
            }
        }
    }
    
    func sendTransaction() {
        guard let amount = amount.value, let recipient = recipient.value else {
            preconditionFailure("Make sure to valide inputs")
        }
        MBProgressHUD.showAdded(to: view.view, animated: true)
        
        let transactionFuture = NetworkingManager.sendTransaction(recipient: recipient, amount: amount)
        transactionFuture.execute { [weak self] result in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.view.view, animated: true)
            switch result {
            case .success(let transactionToken):
                if let accountVC = self.view.previousViewController as? AccountViewController {
                    accountVC.fetchData()
                }
                let transactionVM = TransactionViewModel(transactionToken.transaction)!
                let alertVC = UIAlertController(title: "Success", message: "Transaction succesful!\n \(self.view.userVM.name) -->\(transactionVM.amountText) \(transactionVM.recipient)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: {_ in
                    self.view.navigationController?.popViewController(animated: true)
                })
                alertVC.addAction(okAction)
                self.view.present(alertVC, animated: true, completion: nil)
            case .failure(let error):
                self.view.showAlert(withMessage: error.localizedDescription)
            }
        }
    }
}
