//
//  PassportViewModel.swift
//  PassportKit
//
//  Created by James Wolfe on 25/02/2020.
//  Copyright © 2020 Appoly. All rights reserved.
//



import Foundation
import UIKit
import SwiftUI



open class PassportViewModel: NSObject, ObservableObject {
    
    // MARK: - Variables
    
    @Published public var email: String = ""
    @Published public var password: String = ""
    private let passwordRegex: String?
    private let authController = PassportKitAuthService()
    
    

    // MARK: - Initializers
    
    public init(passwordRegex: String? = nil) {
        self.passwordRegex = passwordRegex
        super.init()
    }
    
    
    
    
    // MARK: - Setters
    
    @objc public func setPassword(_ sender: UITextField) {
        password = sender.text ?? ""
    }
    
    
    @objc public func setEmail(_ sender: UITextField) {
        email = sender.text ?? ""
    }
    
    
    
    // MARK: - Validators
    
    public func validateForLogin(completion: @escaping PassportKitValidationResponse) {
        
        let email = self.email
        let password = self.password
        
        guard !email.isEmpty else {
            DispatchQueue.main.async { completion(PassportKitValidationError.missingEmail) }
            return
        }
        
        guard email.isValidEmail else {
            DispatchQueue.main.async { completion(PassportKitValidationError.invalidEmail) }
            return
        }
        
        guard !password.isEmpty else {
            DispatchQueue.main.async { completion(PassportKitValidationError.missingPassword) }
            return
        }
        
        if let passwordRegex = passwordRegex {
            let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
            guard passwordPredicate.evaluate(with: password) else {
                completion(PassportKitValidationError.invalidPassword)
                return
            }
        }
        
        DispatchQueue.main.async { completion(nil) }
    }
    
}
