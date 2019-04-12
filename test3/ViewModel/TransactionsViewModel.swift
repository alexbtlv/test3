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
    
    internal unowned let view: AccountViewController
    private var transactionVMs = [TransactionViewModel]()
    
    var isEmpty: Bool {
        return transactionVMs.isEmpty
    }
    
    init(view: AccountViewController) {
        self.view = view
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
    
    func fetchTransactions() {
        self.view.refreshControl.beginRefreshing()
        let futureTransactions = NetworkingManager.getTransactions()
        futureTransactions.execute { [weak self] result in
            guard let self = self else { return }
            self.view.refreshControl.endRefreshing()
            switch result {
            case .success(let transactionsT):
                self.transactionVMs = transactionsT.transactions.compactMap { TransactionViewModel($0) }
                self.view.tableView.reloadData()
            case.failure(let error):
                self.view.showAlert(withMessage: error.localizedDescription)
            }
        }
    }
}
