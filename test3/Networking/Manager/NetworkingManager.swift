//
//  NetworkManager.swift
//  Test3
//
//  Created by Alexander Batalov on 2/28/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Alamofire

class NetworkingManager {
    
    @discardableResult private static func performRequest<T:Decodable>(route: PWTestEndPoint, completion: @escaping (Result<T,Error>)->Void) -> DataRequest {
        return AF.request(route).responseDecodable(completionHandler: { (response: DataResponse<T>) in
            completion(response.result)
        })
    }
    
    static func registerUser(username: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        performRequest(route: PWTestEndPoint.registration(username: username, email: email, password: password), completion: completion)
    }
    
    static func getUserInfo(completion: @escaping (Result<User, Error>) -> Void) {
        performRequest(route: PWTestEndPoint.userInfo, completion: completion)
    }
    
    static func getTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void) {
        performRequest(route: PWTestEndPoint.getTransactions, completion: completion)
    }
    
    static func signInUser(email: String, password: String, completion: @escaping (Result<Token, Error>) -> Void) {
        performRequest(route: PWTestEndPoint.login(email: email, password: password), completion: completion)
    }
    
    static func getUsernames(query: String, completion: @escaping (Result<[Recipient], Error>) -> Void) {
        performRequest(route: PWTestEndPoint.filteredUserList(query: query), completion: completion)
    }
    
    static func sendTransaction(recipient: String, amount: Int, completion: @escaping (Result<Transaction, Error>) -> Void) {
        performRequest(route: PWTestEndPoint.createTransaction(recipient: recipient, amount: amount), completion: completion)
    }
}
