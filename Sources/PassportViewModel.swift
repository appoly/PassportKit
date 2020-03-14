//
//  PassportViewModel.swift
//  PassportKit
//
//  Created by James Wolfe on 25/02/2020.
//  Copyright © 2020 Appoly. All rights reserved.
//



import Foundation
import UIKit



public protocol PassportViewDelegate {
    func failed(_ error: String)
    func success()
}



public class PassportViewModel: NSObject {
    
    // MARK: - Variables
    
    private(set) var email: String?
    private(set) var password: String?
    private let delegate: PassportViewDelegate?
    private let authController = AuthNetworkController()
    
    

    // MARK: - Initializers
    
    public init(delegate: PassportViewDelegate?) {
        self.delegate = delegate
        super.init()
    }
    
    
    
    
    // MARK: - Setters
    
    @objc public func setPassword(_ sender: UITextField) {
        password = sender.text
    }
    
    
    @objc public func setEmail(_ sender: UITextField) {
        email = sender.text
    }
    
    
    public func setPassword(string: String) {
        password = string
    }
    
    
    public func setEmail(string: String) {
        email = string
    }
    
    
    
    // MARK: - Validators
    
    public func validateForLogin() -> Bool {
        
        let email = self.email ?? ""
        let password = self.password ?? ""
        
        
        if(email.isEmpty) {
            delegate?.failed(NSLocalizedString("Please enter your email", comment: ""))
            return false
        }
        
        if(!email.isValidEmail()) {
            delegate?.failed(NSLocalizedString("Please enter a valid email", comment: ""))
            return false
        }
        
        
        if(password.isEmpty) {
            delegate?.failed(NSLocalizedString("Please enter your password", comment: ""))
            return false
        }
        
        return true
    }
    
}
