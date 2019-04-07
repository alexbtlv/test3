//
//  TransactionViewModel.swift
//  test3
//
//  Created by Alexander Batalov on 4/6/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

class TransactionViewModel {
    private let transaction: Transaction
    
    var recipient: String {
        return transaction.username
    }
    
    var amountText: String {
        var text = ""
        text += "\(transaction.amount) PW "
        text += transaction.amount < 0 ? "--->" : "from"
        return text
    }
    
    var dateText: String {
        return transaction.date
    }
    
    var resiltingBalance: String {
        return "\(transaction.balance) PW"
    }
    
    var amountColor: UIColor {
        if transaction.amount < 0 {
            return UIColor(red: 0.7765, green: 0, blue: 0, alpha: 1.0)
        } else {
            return UIColor(red: 0, green: 0.698, blue: 0.0078, alpha: 1.0)
        }
    }
    
    init?(_ transaction: Transaction?) {
        guard let transaction = transaction  else { return nil }
        self.transaction = transaction
    }
}
