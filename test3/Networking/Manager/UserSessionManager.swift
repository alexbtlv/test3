//
//  UserSessionManager.swift
//  test3
//
//  Created by Alexander Batalov on 4/6/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

struct UserSessionManager {
    private let router = Router<PWTestEndPoint>()
    
    func signInUser(user: PotentialUserViewModel, completion: @escaping (UserRegistrationResult) -> ()) {
        guard let email = user.email.value?.lowercased(), let password = user.password.value else {
            completion(.failure("Please make sure the email and password inputs are valid"))
            return
        }
        
        router.request(.login(email: email, password: password)) { (data, response, error) in
            
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
                            completion(.failure("Can not parse token"))
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
        case 400: return .failure("You must send email and password.")
        case 401: return .failure("Invalid email or password.")
        case 402...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
