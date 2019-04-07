//
//  CreateTransactionViewController.swift
//  test3
//
//  Created by Alexander Batalov on 4/6/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import MBProgressHUD

class CreateTransactionViewController: UIViewController {
    
    @IBOutlet private weak var recipientTextField: BindingSearchTextField!
    @IBOutlet private weak var amountTextField: BindingTextField!
    
    private let transactionManager = TransactionManager()
    private let newTransaction = PotentialTransactionViewModel()
    
    var userVM: UserViewModel!
    var transactionCopy: TransactionViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Create Transaction"
        newTransaction.senderBalance = userVM.balance
        
        if let transactionCopy = transactionCopy {
            recipientTextField.text = transactionCopy.recipient
            amountTextField.text = "\(abs(transactionCopy.amount))"
            newTransaction.amount.value = abs(transactionCopy.amount)
            newTransaction.recipient.value = transactionCopy.recipient
        }
        
        recipientTextField.bind { [unowned self] in
            self.newTransaction.recipient.value = $0
            if !$0.isEmpty {
                self.getUsernamesForAutocomplete(query: $0)
            }
        }
        
        recipientTextField.itemSelectionHandler = {  [unowned self] filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.recipientTextField.text = item.title
            self.newTransaction.recipient.value = item.title
        }
        
        amountTextField.bind { [unowned self] in
            guard let num = Int($0) else { return }
            self.newTransaction.amount.value = num
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        if newTransaction.isValid {
            MBProgressHUD.showAdded(to: view, animated: true)
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                
                self.transactionManager.sendTransaction(recipient: self.newTransaction.recipient.value!, amount: self.newTransaction.amount.value!, completion: { result in
                    
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        switch result {
                        case .success(let transactionVM):
                            if let accountVC = self.previousViewController as? AccountViewController {
                                accountVC.fetchUser()
                            }
                            self.showAlert(withMessage: "Transaction succesful!\n \(self.userVM.name) -->\(transactionVM.amountText) \(transactionVM.recipient)", success: true)
                        case .failure(let errorMessage):
                            self.showAlert(withMessage: errorMessage)
                        }
                    }
                })
            }
        } else {
            showAlert(withMessage: newTransaction.validationMessage)
        }
    }
    
    private func getUsernamesForAutocomplete(query: String) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.transactionManager.getUsernames(query: query, completion: { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let names):
                        self.recipientTextField.filterStrings(names)
                    case .failure(let errorMessage):
                        self.showAlert(withMessage: errorMessage)
                    }
                }
            })
        }
    }
}
