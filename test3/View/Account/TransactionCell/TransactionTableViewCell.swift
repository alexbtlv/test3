//
//  TransactionTableViewCell.swift
//  test3
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var resultingBalanceLabel: UILabel!
    
    var transactionVM: TransactionViewModel! {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
//        guard let transactionVM = transactionVM else { return }
        dateLabel.text = transactionVM.dateText
        transactionAmountLabel.textColor = transactionVM.amountColor
        transactionAmountLabel.text = transactionVM.amountText
        recipientLabel.text = transactionVM.recipient
        resultingBalanceLabel.text = transactionVM.resiltingBalance
    }
}
