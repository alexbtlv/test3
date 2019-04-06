//
//  User.swift
//  test3
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation



struct UserToken: Codable {
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case user = "user_info_token"
    }
}

struct User: Codable {
    let id: Int
    let name, email: String
    let balance: Int
}

