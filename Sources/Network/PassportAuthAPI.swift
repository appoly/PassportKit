//
//  PassportAuthAPI.swift
//  
//
//  Created by James Wolfe on 05/03/2021.
//



import Foundation



enum PassportAuthAPI {
    
    case login(configuration: PassportConfiguration, model: PassportViewModel)
    case refresh(configuration: PassportConfiguration, token: String)
    
    var url: URL {
        switch self {
            case .login(let configuration, _), .refresh(let configuration, _):
                if case .standard = configuration.mode {
                    return configuration.baseURL.appendingPathComponent("/oauth/token")
                } else {
                    return configuration.baseURL.appendingPathComponent("/api/login")
                }
        }
    }
    
    var parameters: Data? {
        switch self {
            case .login(let configuration, let model):
                switch configuration.mode {
                    case .sanctum:
                    return "username=\(model.email!)&password=\(model.password!)"
                        .addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)?
                        .data(using: .utf8)
                    case .standard(let clientID, let clientSecret):
                        return "username=\(model.email!)&password=\(model.password!)&client_id=\(clientID)&client_secret=\(clientSecret)&grant_type=password"
                        .addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)?
                        .data(using: .utf8)
                }
            case .refresh(let configuration, let token):
                guard case .standard(let clientID, let clientSecret) = configuration.mode else {
                    return nil
                }
            
                return "refresh_token=\(token)&client_id=\(clientID)&client_secret=\(clientSecret)&grant_type=refresh_token"
                .addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)?
                .data(using: .utf8)
        }
    }
    
    var method: String {
        switch self {
            case .login, .refresh:
            return "POST"
        }
    }
    
}
