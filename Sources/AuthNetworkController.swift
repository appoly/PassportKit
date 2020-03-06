//
//  AuthNetworkController.swift
//  PassportKit
//
//  Created by James Wolfe on 25/02/2020.
//  Copyright © 2020 Appoly. All rights reserved.
//



import Foundation
import Alamofire
import CoreLocation



class AuthNetworkController {
    
    public func login(configuration: PassportConfiguration, model: PassportViewModel, completion: @escaping (Bool, NetworkError?) -> ()) -> Void {
        
        guard isNetworkAvailable() else {
            completion(false, NetworkError.noConnection)
            return
        }
        
        let parameters: Parameters = [
            "username" : model.email!,
            "password" : model.password!,
            "client_id" : configuration.clientID,
            "client_secret" : configuration.clientSecret,
            "grant_type" : "password"
        ]
        
        Alamofire.request(configuration.baseURL.appendingPathComponent("/oauth/token"), method: .post, parameters: parameters, encoding: URLEncoding.methodDependent, headers: nil)
            .validate(statusCode: HTTPStatusCode.ok.rawValue..<HTTPStatusCode.multipleChoices.rawValue)
            .responseJSON { (response) in
                switch response.result {
                case .failure(_):
                    switch response.response?.statusCode {
                    case 400:
                        completion(false, NetworkError.messageError(message: NSLocalizedString("Email address or password was incorrect, please try again.", comment: "")))
                    default:
                        completion(false, NetworkError.unknown)
                    }
                case .success(let value):
                    guard let json = value as? [String: Any] else {
                        completion(false, NetworkError.invalidResponse)
                        return
                    }
                    
                    guard let accessToken = json["access_token"] as? String else {
                        if let error = json["error"] as? String,
                            error == "invalid_grant" {
                            completion(false, NetworkError.invalidCredentials)
                        } else {
                            completion(false, NetworkError.unknown)
                        }
                        
                        return
                    }
                    
                    AuthenticationManager(configuration.keychainID).setAuthToken(AuthenticationToken(accessToken: accessToken))
                    completion(true, nil)
                }
                
        }
    }
    
    
    private func isNetworkAvailable() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    private func error(from response: DataResponse<Any>) -> NetworkError? {
        return nil
    }
    
}
