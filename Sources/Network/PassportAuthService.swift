//
//  PassportKitAuthService.swift
//  PassportKit
//
//  Created by James Wolfe on 25/02/2020.
//  Copyright © 2020 Appoly. All rights reserved.
//



import Foundation
import UIKit
import SystemConfiguration



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
        var request = URLRequest(url: api.url)
        request.httpMethod = api.method
        request.httpBody = api.parameters
        request.allHTTPHeaderFields = PassportKitHeaders.defaultHeaders.reduce([String: String](), {
            var newValue = $0
            newValue[$1.name] = $1.value
            return newValue
        })
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else { completion(PassportKitNetworkError.invalidResponse); return }
            guard let data = data, error == nil else { completion(error); return }
            guard (PassportKitHTTPStatusCode.ok.rawValue..<PassportKitHTTPStatusCode.multipleChoices.rawValue).contains(response.statusCode) else {
                switch response.statusCode {
                    case 400, 401:
                        completion(PassportKitNetworkError.messageError(message: NSLocalizedString("Email address or password was incorrect, please try again.", comment: "")))
                    default:
                        completion(PassportKitNetworkError.unknown)
                }
                return
            }
                                                                                                                        
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
        task.resume()
    }
    
    
    
    // MARK: - Utilities
    
    private func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
             return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return isReachable && !needsConnection
    }
    
}
