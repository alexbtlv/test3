//
//  TestEndPoint.swift
//  Test
//
//  Created by Alexander Batalov on 2/28/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

public enum PWTestEndPoint {
    case registration(username: String, email: String, password: String)
}

extension PWTestEndPoint: EndPointType {
    var baseURL: URL {
        return URL(string: "http://193.124.114.46:3001/")!
    }
    
    var path: String {
        switch self {
        case .registration:
            return "users/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .registration:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .registration(let username, let email, let password):
            let bodyParams: [String: Any] = [
                "username" : username,
                "email" : email,
                "password" : password
            ]
            return .requestParameters(bodyParameters: bodyParams, urlParameters: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
}
