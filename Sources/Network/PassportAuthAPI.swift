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
                        let username = model.email!.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""
                        let password = model.password!.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""
                        return "username=\(username)&password=\(password)"
                        .data(using: .utf8)
                    case .standard(let clientID, let clientSecret):
                        let username = model.email!.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""
                        let password = model.password!.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""
                        let clientID = clientID.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""
                        let clientSecret = clientSecret.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""
                        return "username=\(username)&password=\(password)&client_id=\(clientID)&client_secret=\(clientSecret)&grant_type=password"
                            .data(using: .utf8)
                }
            case .refresh(let configuration, let token):
                guard case .standard(var clientID, var clientSecret) = configuration.mode else {
                    return nil
                }
            
                clientID = clientID.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""
                clientSecret = clientSecret.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""
                let token = token.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""
            
                return "refresh_token=\(token)&client_id=\(clientID)&client_secret=\(clientSecret)&grant_type=refresh_token"
                .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?
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
