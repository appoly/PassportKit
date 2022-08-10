//
//  PassportConfiguration.swift
//  
//
//  Created by James Wolfe on 05/03/2021.
//



import Foundation



public struct PassportConfiguration {
    
    let baseURL: URL
    let mode: Mode
    let emailKey: String
    let keychainID: String
    
    
    /// Initializes a new instance of a passport configuration, emailKey defaults to `username`
    public init(emailKey: String = "username", baseURL: URL, mode: Mode, keychainID: String) {
        self.baseURL = baseURL
        self.mode = mode
        self.emailKey = emailKey
        self.keychainID = keychainID
    }
    
}



extension PassportConfiguration {
    
    public enum Mode {
        case standard(clientID: String, clientSecret: String)
        case sanctum
    }
    
}
