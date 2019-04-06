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
    case userInfo(token: String)
    case login(email: String, password: String)
    case transactions(token: String)
    case filteredUserList(query: String, token: String)
    case createTransaction(recipient: String, amount: Int, token: String)
}

extension PWTestEndPoint: EndPointType {
    var baseURL: URL {
        return URL(string: "http://193.124.114.46:3001")!
    }
    
    var path: String {
        switch self {
        case .registration:
            return "/users"
        case .userInfo:
            return "/api/protected/user-info"
        case .login:
            return "/sessions/create"
        case .transactions:
            return "/api/protected/transactions"
        case .filteredUserList:
            return "/api/protected/users/list"
        case .createTransaction:
            return "/api/protected/transactions"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .registration, .login, .filteredUserList, .createTransaction:
            return .post
        case .userInfo, .transactions:
            return .get
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
        
        case .userInfo:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionalHeaders: headers!)
        
        case .login(let email, let password):
            let bodyParams: [String: Any] = [
                "email" : email,
                "password" : password ]
            return .requestParameters(bodyParameters: bodyParams, urlParameters: nil)
        
        case .transactions:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionalHeaders: headers!)
        case .filteredUserList(let query, _):
            let bodyParams: [String: Any] = ["filter":query]
            return .requestParametersAndHeaders(bodyParameters: bodyParams, urlParameters: nil, additionalHeaders: headers!)
        case .createTransaction(let recipient, let amount, _):
            let bodyParams: [String: Any] = [
                "name":recipient,
                "amount":amount]
            return .requestParametersAndHeaders(bodyParameters: bodyParams, urlParameters: nil, additionalHeaders: headers!)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .registration, .login:
            return nil
        case .userInfo(let token), .transactions(let token), .filteredUserList(_ , let token), .createTransaction(_ , _, let token):
            return ["Authorization":"Bearer \(token)"]
        }
    }
    
}


