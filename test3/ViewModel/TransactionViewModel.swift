//
//  TransactionViewModel.swift
//  test3
//
//  Created by Alexander Batalov on 4/6/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

class TransactionViewModel: Equatable {
    
    private let transaction: Transaction
    
    var recipient: String {
        return transaction.username
    }
    
    var amount: Int {
        return transaction.amount
    }
    
    var date: String {
        return transaction.date
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
            return Constants.pwRedColor
        } else {
            return Constants.pwGreenColor
        }
    }
    
    init?(_ transaction: Transaction?) {
        guard let transaction = transaction  else { return nil }
        self.transaction = transaction
    }
    
    static func == (lhs: TransactionViewModel, rhs: TransactionViewModel) -> Bool {
        return lhs.transaction.id == rhs.transaction.id
    }
}
