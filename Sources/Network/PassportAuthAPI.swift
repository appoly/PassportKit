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
    
    var url: URL {
        switch self {
            case .login(let configuration, _):
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
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .login:
                return .post
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.methodDependent
    }
    
}
