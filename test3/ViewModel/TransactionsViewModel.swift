//
//  TransactionsViewModel.swift
//  test3
//
//  Created by Alexander Batalov on 4/6/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation


enum TransactionSortScope: String {
    case name = "name"
    case date = "date"
    case amount = "amount"
}


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
    
    func sortBy(_ scope: TransactionSortScope) {
        var sorted = [TransactionViewModel]()
        switch scope {
        case .name:
            sorted = transactionVMs.sorted { $0.recipient < $1.recipient }
        case .amount:
            sorted = transactionVMs.sorted { $0.amount < $1.amount }
        case .date:
            sorted = transactionVMs.sorted { $0.date < $1.date }
        }
        transactionVMs = transactionVMs == sorted ? transactionVMs.reversed() : sorted
    }
}
