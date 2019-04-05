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
        return "Hello, " + user.name.capitalized
    }
    
    var balanceText: String {
        return "\(user.balance)" + " PW"
    }
    
    init(user: User) {
        self.user = user
    }
}
