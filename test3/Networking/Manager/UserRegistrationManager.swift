//
//  NetworkManager.swift
//  Test3
//
//  Created by Alexander Batalov on 2/28/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
    case success
    case userNotFound = "Oops, user not found"
    case emailTaken = "A user with that email already exists"
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum NetworkResult<String>{
    case success
    case failure(String)
}

enum UserRegistrationResult {
    case success
    case failure(String)
}

struct UserRegistrationManager {
    private let router = Router<PWTestEndPoint>()
    
    func registerUser(user: NewUserViewModel, completion: @escaping (UserRegistrationResult) -> ()) {
        guard let username = user.name.value?.lowercased(), let email = user.email.value?.lowercased(), let password = user.newPassword.value else {
            completion(.failure("Please make sure the name, email and password inputs are valid"))
            return
        }
        
        router.request(.registration(username: username, email: email, password: password)) { (data, response, error) in
            
            if error != nil {
                completion(.failure("Please check your network connection."))
            }
            
            if let response = response as? HTTPURLResponse {
                print(response.debugDescription)
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(NetworkResponse.noData.rawValue))
                        return
                    }
                    
                    do {
                        let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: [])
                        guard let json = jsonObject as? [String: Any], let idToken = json["id_token"] as? String else {
                            completion(.failure("Can not parse auth token"))
                            return
                        }
                        // save token to keychain store
                        let tokenItem = KeychainTokenItem(service: KeychainConfiguration.tokenService, account: KeychainConfiguration.account)
                        try tokenItem.saveToken(idToken)
                        completion(.success)
                    } catch {
                        completion(.failure(NetworkResponse.unableToDecode.rawValue))
                    }
                    
                case .failure(let networkFailureError):
                    completion(.failure(networkFailureError))
                }
            }
        }
    }

    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResult<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 400: return .failure(NetworkResponse.emailTaken.rawValue)
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}


