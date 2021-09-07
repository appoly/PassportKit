//
//  PassportAuthResponse.swift
//  
//
//  Created by James Wolfe on 05/03/2021.
//



import Foundation



internal class PassportAuthResponse: NSObject, Decodable {
    
    // MARK: - Variables
    
    let tokenType: String?
    let expires: Date?
    let accessToken: String
    let refreshToken: String?

    
    
    // MARK: - Coding Keys
    
//    private enum ParentCodingKeys: String, CodingKey {
//        case data
//    }
    
    private enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
    
    
    // MARK: - Initializers
    
    internal required init(from decoder: Decoder) throws {
//        let parentContainer = try decoder.container(keyedBy: ParentCodingKeys.self)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tokenType = try container.decodeIfPresent(String.self, forKey: .tokenType)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        
        if let expiresSeconds = try container.decodeIfPresent(Int.self, forKey: .expiresIn) {
            expires = Calendar.autoupdatingCurrent.date(byAdding: .second, value: expiresSeconds, to: Date())
        } else {
            expires = nil
        }
    }
    
}
