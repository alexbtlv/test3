//
//  TestEndPoint.swift
//  Test
//
//  Created by Alexander Batalov on 2/28/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Alamofire

public enum PWTestEndPoint {
    case registration(username: String, email: String, password: String)
    case userInfo(token: String)
    case login(email: String, password: String)
    case transactions(token: String)
    case filteredUserList(query: String, token: String)
    case createTransaction(recipient: String, amount: Int, token: String)
}

extension PWTestEndPoint {
    
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
    
    var urlParameters: Parameters? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .registration, .login:
            return nil
        case .userInfo(let token), .transactions(let token), .filteredUserList(_ , let token), .createTransaction(_ , _, let token):
            return ["Authorization":"Bearer \(token)"]
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .userInfo, .transactions:
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
        case .filteredUserList(let query, _):
            return [
                Constants.APIParameterKey.filter: query ]
        case .createTransaction(let recipient, let amount, _):
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
        
        if let additionalHeaders = headers {
            for (key, value) in additionalHeaders {
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

