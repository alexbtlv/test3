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
        sendMoneyBuuton.titleLabel?.font = UIFont.fontAwesome(ofSize: 25, style: .solid)
        sendMoneyBuuton.setTitle(String.fontAwesomeIcon(name: .moneyCheckAlt), for: .normal)
        addSubview(contentView)
    }
    
    fileprivate func updateUI() {
        sendMoneyBuuton.isHidden = userVM == nil
        usernameLabel.text = userVM?.greetingText
        balanceLabel.text = userVM?.balanceText
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        do {
            try UserViewModel.logOut()
        } catch {
            print(error)
        }
    }
    
    @IBAction func sendMoneyButtonTapped(_ sender: Any) {
        let createTransactionVC = CreateTransactionViewController(nibName: "CreateTransactionViewController", bundle: nil)
        createTransactionVC.userVM = userVM
        parentViewController?.navigationController?.pushViewController(createTransactionVC, animated: true)
    }
    
    @IBAction func sortByButtonClicked(_ sender: ABRoundedButton) {
        guard let title = sender.titleLabel?.text,
              let scope = TransactionSortScope(rawValue: title),
              let accountTBVC = parentViewController as? AccountViewController else { return }
        accountTBVC.tractionsVM.sortBy(scope)
        accountTBVC.tableView.reloadData()
        
    }
    
}

