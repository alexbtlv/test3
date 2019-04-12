//
//  UserViewModel.swift
//  test3
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation
import MBProgressHUD

class UserViewModel {
    
    internal unowned let view: AccountViewController
    private var user: User?
    
    var greetingText: String {
        if let username = user?.name {
            return "Hey, " + username.capitalized + "!"
        }
        return "Hey!"
    }
    
    var balanceText: String {
        return "\(user?.balance ?? 0)" + " PW"
    }

    var balance: Int {
        return user?.balance ?? 0
    }
    
    var name: String {
        return user?.name ?? ""
    }
    
    init(view: AccountViewController) {
        self.view = view
    }
    
    static func logOut() throws {
        let tokenItem = KeychainTokenItem(service: KeychainConfiguration.tokenService, account: KeychainConfiguration.account)
        try tokenItem.deleteItem()
        AppDelegate.shared.rootViewController.showWelcomeScreen()
    }
    
    func fetchUserData() {
        view.refreshControl.beginRefreshing()
        let futureUser = NetworkingManager.getUserInfo()
        futureUser.execute { [weak self] result  in
            guard let self = self else { return }
            self.view.refreshControl.endRefreshing()
            switch result {
            case .success(let userToken):
                self.user = userToken.user
                self.view.tableView.reloadData()
            case.failure(let error):
                self.view.showAlert(withMessage: error.localizedDescription)
            }
        }
    }
}
