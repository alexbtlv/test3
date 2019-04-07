//
//  TransactionViewModel.swift
//  test3
//
//  Created by Alexander Batalov on 4/6/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

class TransactionViewModel {
    private let transaction: Transaction
    
    var recipient: String {
        return transaction.username
    }
    
    var amountText: String {
        return "\(transaction.amount) PW".replacingOccurrences(of: "-", with: "")
    }
    
    var dateText: String {
        return transaction.date
    }
    
    var resiltingBalance: String {
        return "\(transaction.balance) PW"
    }
    
    init?(_ transaction: Transaction?) {
        guard let transaction = transaction  else { return nil }
        self.transaction = transaction
    }
}
