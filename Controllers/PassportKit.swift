//
//  PassportKit.swift
//  PassportKit
//
//  Created by James Wolfe on 25/02/2020.
//  Copyright © 2020 Appoly. All rights reserved.
//


import Foundation



public struct PassportConfiguration {
    let baseURL: URL
    let clientID: String
    let clientSecret: String
    let keychainID: String
}



class PassportKit: NSObject {
    
    // MARK: - Variables
    
    private let configuration: PassportConfiguration!
    private let delegate: PassportViewDelegate!
    private let authManager: AuthenticationManager!
    
    
    
    // MARK: - Initializers
    
    init(_ configuration: PassportConfiguration, delegate: PassportViewDelegate) {
        self.configuration = configuration
        self.delegate = delegate
        self.authManager = AuthenticationManager(configuration.keychainID)
        super.init()
    }
    
    
    
    // MARK: - Utilities
    
    /// Uses the given configuration to get a users authentication token and store it in the keychain
    /// - Parameter viewModel: View model consisting of a email and a password
    public func authenticate(_ viewModel: PassportViewModel) {
        if(viewModel.validateForLogin()) {
            AuthNetworkController().login(configuration: configuration, model: viewModel) { [weak self] (success, error) in
                if(success) {
                    self?.delegate.success()
                } else {
                    self?.delegate.failed(error?.localizedDescription ?? NetworkError.unknown.localizedDescription)
                }
            }
        }
    }
    
    
    /// Returns a boolean indicating whether a usr is authenticated or not
    public func isAuthenticated() -> Bool {
        return authManager.isAuthenticated()
    }

    
    /// Gets the user's auth token from the keychain, if it is available
    public func getAuthToken() -> String? {
        return authManager.getAuthToken()
    }

    
    /// Removes the users auth token from the keychain
    public func unauthenticate() {
        authManager.removeAuthToken()
    }
    
}
