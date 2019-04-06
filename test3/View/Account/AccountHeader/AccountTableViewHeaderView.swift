//
//  AccountTableViewHeaderView.swift
//  test3
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import FontAwesome_swift

class AccountTableViewHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var sendMoneyBuuton: ABRoundedButton!
    
    var userVM: UserViewModel? {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AccountTableViewHeaderView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
    
    fileprivate func updateUI() {
        usernameLabel.text = userVM?.greetingText
        balanceLabel.text = userVM?.balanceText
        sendMoneyBuuton.titleLabel?.font = UIFont.fontAwesome(ofSize: 25, style: .solid)
        sendMoneyBuuton.setTitle(String.fontAwesomeIcon(name: .moneyCheckAlt), for: .normal)
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        do {
            let tokenItem = KeychainTokenItem(service: KeychainConfiguration.tokenService, account: KeychainConfiguration.account)
            try tokenItem.deleteItem()
            AppDelegate.shared.rootViewController.showWelcomeScreen()
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func sendMoneyButtonTapped(_ sender: Any) {
        let createTransactionVC = CreateTransactionViewController(nibName: "CreateTransactionViewController", bundle: nil)
        parentViewController?.navigationController?.pushViewController(createTransactionVC, animated: true)
    }
}

