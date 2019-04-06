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
    
    init?(_ transaction: Transaction?) {
        guard let transaction = transaction  else { return nil }
        self.transaction = transaction
    }
}
