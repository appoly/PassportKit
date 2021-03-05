//
//  PassportKit.swift
//  PassportKit
//
//  Created by James Wolfe on 25/02/2020.
//  Copyright © 2020 Appoly. All rights reserved.
//


import Foundation




public typealias PassportKitValidationResponse = (Error?) -> Void
public typealias PassportKitAuthenticationResponse = (Error?) -> ()
public typealias PassportKitRefreshResponse = (Error?) -> ()



public class PassportKit: NSObject {
    
    // MARK: - Variables
    
    private let configuration: PassportConfiguration!
    private let delegate: PassportViewDelegate?
    private let authManager: PassportKitAuthenticationManager!
    private let authService = PassportKitAuthService()

    public var isAuthenticated: Bool {
        return authManager.isAuthenticated
    }
    
    public var authToken: String? {
        return authManager.authToken
    }
    
    
    
    // MARK: - Initializers
    
    public init(_ configuration: PassportConfiguration, delegate: PassportViewDelegate?) {
        self.configuration = configuration
        self.delegate = delegate
        self.authManager = PassportKitAuthenticationManager(configuration.keychainID)
        super.init()
    }
    
    
    
    // MARK: - Utilities
    
    /// Uses the given configuration to get a users authentication token and store it in the keychain
    /// - Parameter viewModel: View model consisting of a email and a password
    public func authenticate(_ viewModel: PassportViewModel, completion: PassportKitAuthenticationResponse?) {
        viewModel.validateForLogin { [weak self] error in
            guard let self = self else { return }
            guard error == nil else {
                DispatchQueue.main.async { completion?(error!) }
                return
            }
            
            self.authService.login(configuration: self.configuration, model: viewModel) { error in
                if(error == nil) {
                    DispatchQueue.main.async { completion?(nil) }
                } else {
                    DispatchQueue.main.async { completion?(error!) }
                }
            }
        }
    }
    
    /// Refrshes the user's auth token using given configuration
    /// - Parameter biometricsEnabled: Will trigger a biometric popup prior to refresh
    public func refresh(biometricsEnabled: Bool, completion: PassportKitRefreshResponse) {
        
    }
    
    
    /// Manually sets auth token
    public func setAuthToken(token: String) {
        PassportKitAuthenticationManager(configuration.keychainID).setAuthToken(token)
    }

    
    /// Removes the users auth token from the keychain
    public func unauthenticate() {
        authManager.setAuthToken(nil)
    }
    
}
