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
        
        Alamofire.request(api.url, method: api.method, parameters: api.parameters, encoding: api.encoding, headers: api.headers)
            .validate(statusCode:
                PassportKitHTTPStatusCode.ok.rawValue..<PassportKitHTTPStatusCode.multipleChoices.rawValue)
            .responseJSON { (response) in
                switch response.result {
                case .failure(_):
                    switch response.response?.statusCode {
                    case 400:
                        completion(PassportKitNetworkError.messageError(message: NSLocalizedString("Email address or password was incorrect, please try again.", comment: "")))
                    default:
                        completion(PassportKitNetworkError.unknown)
                    }
                case .success(let value):
                    guard let json = value as? [String: Any] else {
                        completion(PassportKitNetworkError.invalidResponse)
                        return
                    }
                    
                    guard let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed),
                        let response = try? JSONDecoder().decode(PassportAuthResponse.self, from: data) else {
                            completion(PassportKitNetworkError.invalidResponse)
                            return
                    }
                    
                    let manager = PassportKitAuthenticationManager(configuration.keychainID)
                    manager.setAuthToken(response.accessToken)
                    manager.setRefreshToken(response.refreshToken)
                    completion(nil)
                }
                
        }
    }
    
    
    
    // MARK: - Utilities
    
    private func isNetworkAvailable() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    private func error(from response: DataResponse<Any>) -> PassportKitNetworkError? {
        return nil
    }
    
}
