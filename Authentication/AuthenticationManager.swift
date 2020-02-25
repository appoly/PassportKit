//
//  AuthenticationManager.swift
//  PassportKit
//
//  Created by James Wolfe on 25/02/2020.
//  Copyright © 2020 Appoly. All rights reserved.
//



import Foundation
import UIKit
import Valet



class AuthenticationManager: NSObject {
    
    // MARK: - Backend Variables
    
    private let identifier: Identifier!
    private let authTokenKey: String = "AuthToken"
    
    
    
    // MARK: - Initializers
    
    init(_ keychainID: String) {
        identifier = Identifier(nonEmpty: keychainID)!
        super.init()
    }
    
    
    
    // MARK: - CRUD
    
    public func setAuthToken(_ authToken: AuthenticationToken) {
        let valet = Valet.valet(with: identifier, accessibility: .alwaysThisDeviceOnly)
        valet.set(string: authToken.accessToken, forKey: authTokenKey)
    }

    
    public func isAuthenticated() -> Bool {
        return getAuthToken() != nil
    }

    
    public func getAuthToken() -> String? {
        let valet = Valet.valet(with: identifier, accessibility: .alwaysThisDeviceOnly)
        return valet.string(forKey: authTokenKey)
    }

    
    private func removeAuthToken() {
        let valet = Valet.valet(with: identifier, accessibility: .alwaysThisDeviceOnly)
        valet.removeObject(forKey: authTokenKey)
    }
    
    
    public func logout() {
        removeAuthToken()
    }
}
