//
//  TransactionTableViewCell.swift
//  test3
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var transactionAmountLabel: UILabel!
    @IBOutlet private weak var recipientLabel: UILabel!
    @IBOutlet private weak var resultingBalanceLabel: UILabel!
    
    var transactionVM: TransactionViewModel! {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        dateLabel.text = transactionVM.dateText
        transactionAmountLabel.textColor = transactionVM.amountColor
        transactionAmountLabel.text = transactionVM.amountText
        recipientLabel.text = transactionVM.recipient
        resultingBalanceLabel.text = transactionVM.resiltingBalance
    }
}
