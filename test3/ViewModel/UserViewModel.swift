//
//  UserViewModel.swift
//  test3
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation


class UserViewModel {
    
    private let user: User
    
    var greetingText: String {
        return "Hey, " + user.name.capitalized + "!"
    }
    
    var balanceText: String {
        return "\(user.balance)" + " PW"
    }
    
    var balance: Int {
        return user.balance
    }
    
    var name: String {
        return user.name
    }
    
    init(user: User) {
        self.user = user
    }
    
    static func logOut() throws {
        let tokenItem = KeychainTokenItem(service: KeychainConfiguration.tokenService, account: KeychainConfiguration.account)
        try tokenItem.deleteItem()
        AppDelegate.shared.rootViewController.showWelcomeScreen()
    }
}
