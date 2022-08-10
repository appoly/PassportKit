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
    
    private static let allowedCharacters: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }()
    
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
                        let username = model.email.addingPercentEncoding(withAllowedCharacters: Self.allowedCharacters) ?? ""
                    let password = model.password.addingPercentEncoding(withAllowedCharacters: Self.allowedCharacters) ?? ""
                    return "\(configuration.emailKey)=\(username)&password=\(password)"
                        .data(using: .utf8)
                    case .standard(let clientID, let clientSecret):
                        let username = model.email.addingPercentEncoding(withAllowedCharacters: Self.allowedCharacters) ?? ""
                        let password = model.password.addingPercentEncoding(withAllowedCharacters: Self.allowedCharacters) ?? ""
                        let clientID = clientID.addingPercentEncoding(withAllowedCharacters: Self.allowedCharacters) ?? ""
                        let clientSecret = clientSecret.addingPercentEncoding(withAllowedCharacters: Self.allowedCharacters) ?? ""
                        return "\(configuration.emailKey)=\(username)&password=\(password)&client_id=\(clientID)&client_secret=\(clientSecret)&grant_type=password"
                            .data(using: .utf8)
                }
            case .refresh(let configuration, let token):
                guard case .standard(var clientID, var clientSecret) = configuration.mode else {
                    return nil
                }
            
                clientID = clientID.addingPercentEncoding(withAllowedCharacters: Self.allowedCharacters) ?? ""
                clientSecret = clientSecret.addingPercentEncoding(withAllowedCharacters: Self.allowedCharacters) ?? ""
                let token = token.addingPercentEncoding(withAllowedCharacters: Self.allowedCharacters) ?? ""
            
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
