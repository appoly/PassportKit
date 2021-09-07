//
//  SanctumAuthResponse.swift
//  
//
//  Created by James Wolfe on 07/09/2021.
//



import Foundation



internal class SanctumAuthResponse: NSObject, Decodable {
    
    // MARK: - Variables
    
    let token: String?

    
    
    // MARK: - Coding Keys
    
    private enum ParentCodingKeys: String, CodingKey {
        case data
    }
    
    private enum CodingKeys: String, CodingKey {
        case token
    }
    
    
    // MARK: - Initializers
    
    internal required init(from decoder: Decoder) throws {
        let parentContainer = try decoder.container(keyedBy: ParentCodingKeys.self)
        let container = try parentContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        
        token = try container.decodeIfPresent(String.self, forKey: .token)
    }
    
}
