//
//  PassportKitNetworkErrors.swift
//  PassportKit
//
//  Created by James Wolfe on 25/02/2020.
//  Copyright © 2020 Appoly. All rights reserved.
//



import Foundation



enum PassportKitNetworkError: Error {
    case unknown
    case noConnection
    case noHost
    case noTenantCredentials
    case noResponseData
    case invalidResponse
    case serverError(reason: String)
    case requestError(reason: String)
    case internalError(reason: String)
    case messageError(message: String)
    case invalidCredentials
    case invalidUserRole
}



extension PassportKitNetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .noConnection:
                return NSLocalizedString("Please check your internet connection.", comment: "")
            case .noHost:
                return NSLocalizedString("The specified host is invalid.", comment: "")
            case .noTenantCredentials:
                return NSLocalizedString("Your local credentials are invalid.", comment: "")
            case .noResponseData:
                return NSLocalizedString("There was no response data.", comment: "")
            case .invalidResponse:
                return NSLocalizedString("The response from the server was invalid.", comment: "")
            case .serverError(let reason):
                let localizedString = String(format: NSLocalizedString("The server reported an error: %@", comment: ""), reason)
                return localizedString
            case .invalidCredentials:
                return NSLocalizedString("Your username or password were incorrect.", comment: "")
            case .requestError(let reason):
                let localizedString = String(format: NSLocalizedString("An API request failed: %@", comment: ""), reason)
                return localizedString
            case .internalError(let reason):
                let localizedString = String(format: NSLocalizedString("An error occurred on the device: %@", comment: ""), reason)
                return localizedString
            case .messageError(let message):
                return NSLocalizedString(message, comment: "")
            case .invalidUserRole:
                return NSLocalizedString("Your user role is not supported by the app.", comment: "")
            default:
                return NSLocalizedString("An unidentified error occurred.", comment: "")
        }
    }
}
