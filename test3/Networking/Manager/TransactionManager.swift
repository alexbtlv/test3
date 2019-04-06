//
//  TransactionManager.swift
//  test3
//
//  Created by Alexander Batalov on 4/6/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

enum UsernamesResult {
    case success([String])
    case failure(String)
}

struct TransactionManager {
    private let router = Router<PWTestEndPoint>()
    
    func getUsernames(query: String, completion: @escaping (UsernamesResult)->()) {
        do {
            let tokenItem = KeychainTokenItem(service: KeychainConfiguration.tokenService, account: KeychainConfiguration.account)
            let token = try tokenItem.readToken()
            
            router.request(.filteredUserList(query: query, token: token)) { (data, response, error) in
                
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
                            let recipients = try JSONDecoder().decode([Recipient].self, from: responseData)
                            let names = recipients.map { $0.name }
                            completion(.success(names))
                        } catch {
                            completion(.failure(NetworkResponse.unableToDecode.rawValue))
                        }
                    case .failure(let errorMessage):
                        completion(.failure(errorMessage))
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
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
