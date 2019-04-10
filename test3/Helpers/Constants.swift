//
//  Constants.swift
//  test3
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

struct Constants {

    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
        static let username = "username"
        static let filter = "filter"
        static let name = "name"
        static let amount = "amount"
    }
    
    enum HTTPHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
    
    static let needsToAuthenticate = "needsToAuthenticate"
    
    static var pwRedColor: UIColor {
        return UIColor(red: 0.7765, green: 0, blue: 0, alpha: 1)
    }
    static var pwGreenColor: UIColor {
        return UIColor(red: 0, green: 0.698, blue: 0.0078, alpha: 1)
    }
    static var pwOrangeColor: UIColor {
        return UIColor(red: 255/255, green: 155/255, blue: 0/255, alpha: 1)
    }
}
