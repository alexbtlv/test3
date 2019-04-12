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
            
            let transactionFuture = NetworkingManager.sendTransaction(recipient: newTransaction.recipient.value!, amount: newTransaction.amount.value!)
            transactionFuture.execute { [weak self] result in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch result {
                case .success(let transactionToken):
                    if let accountVC = self.previousViewController as? AccountViewController {
                        accountVC.fetchData()
                    }
                    let transactionVM = TransactionViewModel(transactionToken.transaction)!
                    let alertVC = UIAlertController(title: "Success", message: "Transaction succesful!\n \(self.userVM.name) -->\(transactionVM.amountText) \(transactionVM.recipient)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: {_ in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)
                case .failure(let error):
                    self.showAlert(withMessage: error.localizedDescription)
                }
            }
        } else {
            showAlert(withMessage: newTransaction.validationMessage)
        }
    }
    
    private func getUsernamesForAutocomplete(query: String) {
        let namesFuture = NetworkingManager.getUsernames(query: query)
        namesFuture.execute { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let recipients):
                let names = recipients.map { $0.name }
                self.recipientTextField.filterStrings(names)
            case .failure(let errorMessage):
                self.showAlert(withMessage: errorMessage.localizedDescription)
            }
        }
    }
}
