//
//  NetworkManager.swift
//  Test3
//
//  Created by Alexander Batalov on 2/28/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Alamofire
import PromisedFuture

class NetworkingManager {
    
    @discardableResult private static func performRequest<T:Decodable>(route: PWTestEndPoint) -> Future<T> {
        return Future(operation: { completion in
            AF.request(route).responseDecodable(completionHandler: { (response: DataResponse<T>) in
                print(response.debugDescription)
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        })
    }
    
    static func registerUser(username: String, email: String, password: String) -> Future<Token> {
        return performRequest(route: PWTestEndPoint.registration(username: username, email: email, password: password))
    }
    
    static func getUserInfo() -> Future<UserToken> {
        return performRequest(route: PWTestEndPoint.userInfo)
    }
    
    static func getTransactions() -> Future<TransactionsToken> {
        return performRequest(route: PWTestEndPoint.getTransactions)
    }
    
    static func signInUser(email: String, password: String) -> Future<Token> {
        return performRequest(route: PWTestEndPoint.login(email: email, password: password))
    }
    
    static func getUsernames(query: String) -> Future<[Recipient]> {
        return performRequest(route: PWTestEndPoint.filteredUserList(query: query))
    }
    
    static func sendTransaction(recipient: String, amount: Int) -> Future<TransactionToken> {
        return performRequest(route: PWTestEndPoint.createTransaction(recipient: recipient, amount: amount))
    }
}
