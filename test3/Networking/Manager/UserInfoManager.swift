//
//  UserInfoManager.swift
//  test3
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

enum UserInfoResult {
    case success(UserViewModel)
    case failure(String)
}

enum TransactionsResult {
    case success([TransactionViewModel])
    case failure(String)
}

struct UserInfoManager {
    private let router = Router<PWTestEndPoint>()
    
    func getUserInfo(completion: @escaping (UserInfoResult) -> ()) {
        do {
            let tokenItem = KeychainTokenItem(service: KeychainConfiguration.tokenService, account: KeychainConfiguration.account)
            let token = try tokenItem.readToken()
            router.request(.userInfo(token: token)) { (data, response, error) in
                
                if error != nil {
                    completion(.failure("Please check your network connection."))
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(.failure(NetworkResponse.noData.rawValue))
                            return
                        }
                        
                        do {
                            let userToken = try JSONDecoder().decode(UserToken.self, from: responseData)
                            let userVM = UserViewModel(user: userToken.user)
                            completion(.success(userVM))
                        } catch {
                            completion(.failure(NetworkResponse.unableToDecode.rawValue))
                        }
                    case .failure(let errorMessage):
                        if errorMessage == NetworkResponse.authenticationError.rawValue {
                            // user performed request while not being authetnicated. Force log out.
                            DispatchQueue.main.async {
                                do {
                                    try UserViewModel.logOut()
                                } catch {
                                    completion(.failure(errorMessage + "\n" + error.localizedDescription))
                                }
                            }
                        } else {
                            completion(.failure(errorMessage))
                        }
                    }
                }
            }
        } catch {
            completion(.failure(error.localizedDescription))
        }
        
    }
    
    func getTransactions(completion: @escaping (TransactionsResult)->()) {
        do {
            let tokenItem = KeychainTokenItem(service: KeychainConfiguration.tokenService, account: KeychainConfiguration.account)
            let token = try tokenItem.readToken()
            
            router.request(.transactions(token: token)) { (data, response, error) in
                if error != nil {
                    completion(.failure("Please check your network connection."))
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(.failure(NetworkResponse.noData.rawValue))
                            return
                        }
                        
                        do {
                            let transToken = try JSONDecoder().decode(TransactionsToken.self, from: responseData)
                            let transactionVMs = transToken.transactions.compactMap { TransactionViewModel($0) }
                            completion(.success(transactionVMs))
                        } catch {
                            completion(.failure(NetworkResponse.unableToDecode.rawValue))
                        }
                    case .failure(let errorMessage):
                        if errorMessage == NetworkResponse.authenticationError.rawValue {
                            // user performed request while not being authetnicated. Force log out.
                            DispatchQueue.main.async {
                                do {
                                    try UserViewModel.logOut()
                                } catch {
                                    completion(.failure(errorMessage + "\n" + error.localizedDescription))
                                }
                            }
                        } else {
                            completion(.failure(errorMessage))
                        }
                    }
                }
            }
        } catch {
            completion(.failure(error.localizedDescription))
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResult<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 400: return .failure(NetworkResponse.userNotFound.rawValue)
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
