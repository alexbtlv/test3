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
    
    @IBOutlet weak var recipientTextField: BindingSearchTextField!
    @IBOutlet private weak var amountTextField: BindingTextField!
    
    private var newTransaction: PotentialTransactionViewModel!

    var userVM: UserViewModel!
    var transactionCopy: TransactionViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newTransaction = PotentialTransactionViewModel(view: self)
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
            self.newTransaction.getUsernamesForAutocomplete()
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
            newTransaction.sendTransaction()
        } else {
            showAlert(withMessage: newTransaction.validationMessage)
        }
    }
}
