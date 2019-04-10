//
//  TestEndPoint.swift
//  Test
//
//  Created by Alexander Batalov on 2/28/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Alamofire

public typealias HTTPHeaders = [String:String]

public enum PWTestEndPoint {
    case registration(username: String, email: String, password: String)
    case userInfo
    case login(email: String, password: String)
    case getTransactions
    case filteredUserList(query: String)
    case createTransaction(recipient: String, amount: Int)
}

extension PWTestEndPoint {
    
    private var baseURL: URL {
        return URL(string: "http://193.124.114.46:3001")!
    }
    
    private var path: String {
        switch self {
        case .registration:
            return "/users"
        case .userInfo:
            return "/api/protected/user-info"
        case .login:
            return "/sessions/create"
        case .getTransactions:
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
        case .userInfo, .getTransactions:
            return .get
        }
    }
    
    var urlParameters: Parameters? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .registration, .login:
            return nil
        case .userInfo, .getTransactions, .filteredUserList, .createTransaction:
            guard let token = KeychainTokenItem.token else {
                preconditionFailure("You need to be authenticated first!")
            }
            return ["Authorization":"Bearer \(token)"]
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .userInfo, .getTransactions:
            return nil
        case .registration(let username, let email, let password):
            return [
                Constants.APIParameterKey.email : email,
                Constants.APIParameterKey.password : password,
                Constants.APIParameterKey.username: username ]
        case .login(let email, let password):
            return [
                Constants.APIParameterKey.email: email,
                Constants.APIParameterKey.password: password ]
        case .filteredUserList(let query):
            return [
                Constants.APIParameterKey.filter: query ]
        case .createTransaction(let recipient, let amount):
            return [
                Constants.APIParameterKey.name: recipient,
                Constants.APIParameterKey.amount: amount
            ]
        }
    }
}

extension PWTestEndPoint: URLRequestConvertible {
    
    public func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = httpMethod.rawValue
        
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HTTPHeaderField.contentType.rawValue)
        
        if let headers = headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let bodyParameters = bodyParameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}

