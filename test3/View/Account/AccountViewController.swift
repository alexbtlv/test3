//
//  AccountViewController.swift
//  test3
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import MBProgressHUD

class AccountViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let cellReuseIdentifier = "TransactionTableViewCell"
    private let tableViewHeaderHeight: CGFloat = 200
    private let userInfoManager = UserInfoManager()
    
    private var userVM: UserViewModel?
    private var tractionsVM = TransactionsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUser()
    }

    private func setupUI() {
        title = "Account"
        tableView.rowHeight = 100
        let cellNib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    private func reloadData() {
        if tractionsVM.isEmpty {
            tableView.setEmptyMessage("You don't have any transactions, yet.\n Pull to refresh or create one.")
        } else {
            tableView.removeEmptyMessge()
        }
        tableView.reloadData()
    }
    
    private func fetchUser() {
        MBProgressHUD.showAdded(to: view, animated: true)
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            self.userInfoManager.getUserInfo(completion: { result in
                
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    switch result {
                    case.success(let userViewModel):
                        self.userVM = userViewModel
                        self.reloadData()
                    case .failure(let error):
                        self.showAlert(withMessage: error)
                    }
                }
            }) // end of get user info
            
            self.userInfoManager.getTransactions(completion: { result in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    switch result {
                    case .success(let transactionVMs):
                        self.tractionsVM.setTransactions(transactionVMs)
                        self.reloadData()
                    case .failure(let error):
                        self.showAlert(withMessage: error)
                    }
                }
                
            }) // end of get transactions
        }
    }
}

// MARK: - Table view data source

extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tractionsVM.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) else {
            preconditionFailure("Plese make sure to register Nib for Cell Reuse Identifier.")
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}

extension AccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = AccountTableViewHeaderView()
            header.userVM = userVM
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewHeaderHeight
    }
}
