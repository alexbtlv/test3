//
//  TransactionsViewModel.swift
//  test3
//
//  Created by Alexander Batalov on 4/6/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

class TransactionsViewModel {
    
    private var transactionVMs = [TransactionViewModel]()
    
    var isEmpty: Bool {
        return transactionVMs.isEmpty
    }
    
    
    func setTransactions(_ transactionsVMs: [TransactionViewModel]) {
        self.transactionVMs = transactionsVMs
    }
    
    func numberOfSctions() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        switch section {
        case 0:
            return transactionVMs.count
        default:
            return 0
        }
    }
    
    func transactionVM(forRowAt indexPath: IndexPath) -> TransactionViewModel {
        return transactionVMs[indexPath.row]
    }
}
