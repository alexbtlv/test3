//
//  AccountViewController.swift
//  test3
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private let cellReuseIdentifier = "TransactionTableViewCell"
    private let tableViewHeaderHeight: CGFloat = 220
    
    var userVM: UserViewModel?
    var tractionsVM = TransactionsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUser()
    }

    private func setupUI() {
        title = "Account"
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.rowHeight = 100
        let cellNib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(fetchUser), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refresing user data ...", attributes: nil)
    }
    
    private func reloadData() {
        if tractionsVM.isEmpty {
            tableView.setEmptyMessage("You don't have any transactions, yet.\n Pull to refresh or create one.")
        } else {
            tableView.removeEmptyMessge()
        }
        tableView.reloadData()
    }
    
    @objc func fetchUser() {
        refreshControl.beginRefreshing()
        
        let futureUser = NetworkingManager.getUserInfo()
        futureUser.execute { [weak self] result  in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let userToken):
                self.userVM = UserViewModel(user: userToken.user)
                self.tableView.reloadData()
            case.failure(let error):
                self.showAlert(withMessage: error.localizedDescription)
            }
        }

        let futureTransactions = NetworkingManager.getTransactions()
        futureTransactions.execute { [weak self] result in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let transactionsT):
                let tVMs = transactionsT.transactions.compactMap { TransactionViewModel($0) }
                self.tractionsVM.setTransactions(tVMs)
                self.tableView.reloadData()
            case.failure(let error):
                self.showAlert(withMessage: error.localizedDescription)
            }
        }
    }
}

// MARK: - Table view data source

extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tractionsVM.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? TransactionTableViewCell else {
            preconditionFailure("Plese make sure to register Nib for Cell Reuse Identifier.")
        }
        cell.transactionVM = tractionsVM.transactionVM(forRowAt: indexPath)
        return cell
    }
}

extension AccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let createTransactionVC = CreateTransactionViewController(nibName: "CreateTransactionViewController", bundle: nil)
        createTransactionVC.userVM = userVM
        createTransactionVC.transactionCopy = tractionsVM.transactionVM(forRowAt: indexPath)
        navigationController?.pushViewController(createTransactionVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
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
