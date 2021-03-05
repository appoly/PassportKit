//
//  ValidationErrors.swift
//  
//
//  Created by James Wolfe on 05/03/2021.
//



import Foundation



public enum PassportKitValidationError: Error {
    case missingEmail
    case missingPassword
    case invalidEmail
    case invalidPassword
}



extension PassportKitValidationError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
            case .missingEmail:
                return NSLocalizedString("Please enter your email", comment: "")
            case .missingPassword:
                return NSLocalizedString("Please enter your password", comment: "")
            case .invalidEmail:
                return NSLocalizedString("Please enter a valid email", comment: "")
            case .invalidPassword:
                return NSLocalizedString("Please enter a valid password", comment: "")
        }
    }
    
}
