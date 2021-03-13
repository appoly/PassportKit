//
//  PassportAuthAPI.swift
//  
//
//  Created by James Wolfe on 05/03/2021.
//



import Foundation
import Alamofire



enum PassportAuthAPI {
    
    case login(configuration: PassportConfiguration, model: PassportViewModel)
    case refresh(configuration: PassportConfiguration, token: String)
    
    var url: URL {
        switch self {
            case .login(let configuration, _), .refresh(let configuration, _):
                return configuration.baseURL.appendingPathComponent("/oauth/token")
        }
    }
    
    var parameters: Parameters? {
        switch self {
            case .login(let configuration, let model):
                return [
                    "username" : model.email!,
                    "password" : model.password!,
                    "client_id" : configuration.clientID,
                    "client_secret" : configuration.clientSecret,
                    "grant_type" : "password"
                ]
        case .refresh(let configuration, let token):
            return [
                "grant_type": "refresh_token",
                "refresh_token": token,
                "client_id": configuration.clientID,
                "client_secret": configuration.clientSecret,
                "scope": ""
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .login, .refresh:
                return .post
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
}
