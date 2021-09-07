//
//  PassportKitAuthService.swift
//  PassportKit
//
//  Created by James Wolfe on 25/02/2020.
//  Copyright © 2020 Appoly. All rights reserved.
//



import Foundation
import Alamofire



class PassportKitAuthService {
    
    
    // MARK: - Network Calls
    
    public func login(configuration: PassportConfiguration, model: PassportViewModel, completion: @escaping PassportKitAuthenticationResponse) -> Void {
        
        guard isNetworkAvailable() else {
            completion(PassportKitNetworkError.noConnection)
            return
        }
        
        let api: PassportAuthAPI = .login(configuration: configuration, model: model)
        authRequest(configuration: configuration, api: api, completion: completion)
    }
    
    
    public func refresh(configuration: PassportConfiguration, completion: @escaping PassportKitRefreshResponse) {
        
        guard isNetworkAvailable() else {
            completion(PassportKitNetworkError.noConnection)
            return
        }
        
        let manager = PassportKitAuthenticationManager(configuration.keychainID)
        if let refreshToken = manager.refreshToken {
            let api: PassportAuthAPI = .refresh(configuration: configuration, token: refreshToken)
            authRequest(configuration: configuration, api: api, completion: completion)
        } else {
            completion(PassportKitNetworkError.internalError(reason: "No refresh token found."))
        }
    }
    
    
    private func authRequest(configuration: PassportConfiguration, api: PassportAuthAPI, completion: @escaping (Error?) -> Void) {
        Session.default.request(api.url, method: api.method, parameters: api.parameters, encoding: api.encoding, headers: api.headers)
            .validate(statusCode:
                PassportKitHTTPStatusCode.ok.rawValue..<PassportKitHTTPStatusCode.multipleChoices.rawValue)
            .responseData { (response) in
                switch response.result {
                case .failure(_):
                    switch response.response?.statusCode {
                    case 400:
                        completion(PassportKitNetworkError.messageError(message: NSLocalizedString("Email address or password was incorrect, please try again.", comment: "")))
                    default:
                        completion(PassportKitNetworkError.unknown)
                    }
                case .success(let data):
                    let manager = PassportKitAuthenticationManager(configuration.keychainID)
                    
                    switch configuration.mode {
                        case .sanctum:
                            guard let response = try? JSONDecoder().decode(SanctumAuthResponse.self, from: data) else {
                                    completion(PassportKitNetworkError.invalidResponse)
                                    return
                            }
                            
                            manager.setAuthToken(response.token)
                        case .standard:
                            guard let response = try? JSONDecoder().decode(PassportAuthResponse.self, from: data) else {
                                    completion(PassportKitNetworkError.invalidResponse)
                                    return
                            }
                            
                            manager.setAuthToken(response.accessToken)
                            manager.setRefreshToken(response.refreshToken)
                            
                    }
                    
                    completion(nil)
                }
        }
    }
    
    
    
    // MARK: - Utilities
    
    private func isNetworkAvailable() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    private func error(from response: DataResponse<Any, Error>) -> PassportKitNetworkError? {
        return nil
    }
    
}
