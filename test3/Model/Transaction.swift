//
//  Transaction.swift
//  test3
//
//  Created by Alexander Batalov on 4/6/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

struct TransactionsToken: Codable {
    let transactions: [Transaction?]
    
    enum CodingKeys: String, CodingKey {
        case transactions = "trans_token"
    }
}

struct TransactionToken: Codable {
    let transaction: Transaction
    
    enum CodingKeys: String, CodingKey {
        case transaction = "trans_token"
    }
}

struct Transaction: Codable {
    let id: Int
    let date: String
    let username: String
    let amount: Int
    let balance: Int
}
