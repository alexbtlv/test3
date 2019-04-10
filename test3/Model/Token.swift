//
//  Token.swift
//  test3
//
//  Created by Alexander Batalov on 4/10/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

struct Token: Codable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "id_token"
    }
}
