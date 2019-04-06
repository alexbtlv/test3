//
//  CreateTransactionViewController.swift
//  test3
//
//  Created by Alexander Batalov on 4/6/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import SearchTextField

class CreateTransactionViewController: UIViewController {
    
    @IBOutlet private weak var recipientTextField: SearchTextField!
    @IBOutlet private weak var amountTextField: UITextField!
    
    private let transactionManager = TransactionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Create Transaction"
        recipientTextField.delegate = self
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
    }
}


extension CreateTransactionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return true
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            self.transactionManager.getUsernames(query: text, completion: { result in
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
        
        return true
    }
}
