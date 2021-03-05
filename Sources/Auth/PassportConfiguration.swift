//
//  PassportConfiguration.swift
//  
//
//  Created by James Wolfe on 05/03/2021.
//



import Foundation



public struct PassportConfiguration {
    
    let baseURL: URL
    let clientID: String
    let clientSecret: String
    let keychainID: String
    
    public init(baseURL: URL, clientID: String, clientSecret: String, keychainID: String) {
        self.baseURL = baseURL
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.keychainID = keychainID
    }
}
