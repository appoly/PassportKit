//
//  PassportKit.swift
//  PassportKit
//
//  Created by James Wolfe on 25/02/2020.
//  Copyright © 2020 Appoly. All rights reserved.
//


import Foundation
import LocalAuthentication
import SwiftUI




public typealias PassportKitValidationResponse = (Error?) -> Void
public typealias PassportKitAuthenticationResponse = (Error?) -> ()
public typealias PassportKitRefreshResponse = (Error?) -> ()



public class PassportKit: NSObject, ObservableObject {
    
    // MARK: - Enums
    
    private enum RefreshResult {
        case authorised
        case unauthorised
        case lockout
        case cancelled
    }
    
    
    
    // MARK: - Variables
    
    private var configuration: PassportConfiguration!
    private var authManager: PassportKitAuthenticationManager!
    private let authService = PassportKitAuthService()
    
    private static var passportKit: PassportKit?
    public class var shared: PassportKit {
        get {
            passportKit = passportKit == nil ? PassportKit() : passportKit
            return passportKit!
        }
    }

    @Published public var isAuthenticated: Bool = false
    
    public var authToken: String? {
        return authManager.authToken
    }
    
    
    
    // MARK: - Setup
    
    public func setup(_ configuration: PassportConfiguration) {
        self.configuration = configuration
        self.authManager = PassportKitAuthenticationManager(configuration.keychainID)
        withAnimation { [weak self] in
            guard let self = self else { return }
            self.isAuthenticated = self.authManager.isAuthenticated
        }
        NotificationCenter.default.addObserver(forName: .passportKitAuthenticationStateChanged, object: nil, queue: .main) { _ in
            withAnimation { [weak self] in
                guard let self = self else { return }
                self.isAuthenticated = self.authManager.isAuthenticated
            }
        }
    }
    
    
    
    // MARK: - Utilities
    
    /// Uses the given configuration to get a users authentication token and store it in the keychain
    /// - Parameter viewModel: View model consisting of a email and a password
    public func authenticate(_ viewModel: PassportViewModel, completion: PassportKitAuthenticationResponse?, additionalHeaders: [String: String]? = nil) {
        viewModel.validateForLogin { [weak self] error in
            guard let self = self else { return }
            guard error == nil else {
                DispatchQueue.main.async { completion?(error!) }
                return
            }
            
            self.authService.login(configuration: self.configuration, model: viewModel, additionalHeaders: additionalHeaders) { error in
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
    public func refresh(biometricsEnabled: Bool, reason: String? = nil, additionalHeaders: [String: String]? = nil, completion: @escaping PassportKitRefreshResponse) throws {
        guard case .standard = configuration.mode else {
            throw PassportKitNetworkError.notAvailableInSactum
        }
        ownershipAuthentication(policy: biometricsEnabled ? .deviceOwnerAuthenticationWithBiometrics : .deviceOwnerAuthentication) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .authorised:
                self.authService.refresh(configuration: self.configuration, additionalHeaders: additionalHeaders, completion: { error in
                        completion(error)
                    })
                default:
                    completion(PassportKitNetworkError.internalError(reason: "Biometric identification failed."))
            }
        }
    }
    
    
    public func localAuthententication(biometricsEnabled: Bool, completion: @escaping (Bool) -> Void) {
        ownershipAuthentication(policy: biometricsEnabled ? .deviceOwnerAuthenticationWithBiometrics : .deviceOwnerAuthentication) { result in
            completion(result == .authorised)
        }
    }
    
    
    private func ownershipAuthentication(policy: LAPolicy, reason: String? = nil, completion: @escaping (RefreshResult) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        let reasonString = reason ?? "Authentication is needed to access your account"
        if context.canEvaluatePolicy(policy, error: &error) {
            context.evaluatePolicy(policy, localizedReason: reasonString) { (success, evalPolicyError) in
                guard success, evalPolicyError == nil else {
                    switch evalPolicyError!._code {
                        case LAError.systemCancel.rawValue,
                             LAError.userCancel.rawValue,
                             LAError.userFallback.rawValue:
                            completion(.cancelled)
                            return
                        case LAError.biometryLockout.rawValue:
                            completion(.lockout)
                            return
                    default:
                        return
                    }
                }
                
                completion(.authorised)
            }
        } else {
            switch error!.code{
                case Int(kLAErrorBiometryNotEnrolled):
                    ownershipAuthentication(policy: .deviceOwnerAuthentication, completion: completion)
                case LAError.passcodeNotSet.rawValue:
                    completion(.authorised)
                default:
                    if(policy == .deviceOwnerAuthenticationWithBiometrics) {
                        ownershipAuthentication(policy: .deviceOwnerAuthentication, completion: completion)
                    } else {
                        completion(.unauthorised)
                    }
            }
        }
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
