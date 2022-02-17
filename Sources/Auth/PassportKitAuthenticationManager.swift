//
//  PassportKitAuthenticationManager.swift
//  PassportKit
//
//  Created by James Wolfe on 25/02/2020.
//  Copyright © 2020 Appoly. All rights reserved.
//



import Foundation
import UIKit
import Valet



extension Notification.Name {
    public static let passportKitAuthenticationStateChanged: Notification.Name = .init(rawValue: "PassportKitAuthenticationStateChanged")
}



class PassportKitAuthenticationManager: NSObject {
    
    // MARK: - Backend Variables
    
    private let identifier: Identifier!
    private let authTokenKey: String = "AuthToken"
    private let refreshTokenKey: String = "RefreshToken"
    
    public var isAuthenticated: Bool {
        return authToken != nil
    }

    
    public var authToken: String? {
        let valet = Valet.valet(with: identifier, accessibility: .alwaysThisDeviceOnly)
        return valet.string(forKey: authTokenKey)
    }
    
    
    public var refreshToken: String? {
        let valet = Valet.valet(with: identifier, accessibility: .alwaysThisDeviceOnly)
        return valet.string(forKey: refreshTokenKey)
    }
    
    
    
    // MARK: - Initializers
    
    init(_ keychainID: String) {
        identifier = Identifier(nonEmpty: keychainID)!
        super.init()
    }
    
    
    
    // MARK: - CRUD
    
    public func setAuthToken(_ authToken: String?) {
        let valet = Valet.valet(with: identifier, accessibility: .alwaysThisDeviceOnly)
        if let authToken = authToken {
            valet.set(string: authToken, forKey: authTokenKey)
        } else {
            valet.removeObject(forKey: authTokenKey)
        }
        NotificationCenter.default.post(name: .passportKitAuthenticationStateChanged, object: nil)
    }
    
    
    public func setRefreshToken(_ refreshToken: String?) {
        let valet = Valet.valet(with: identifier, accessibility: .alwaysThisDeviceOnly)
        if let refreshToken = refreshToken {
            valet.set(string: refreshToken, forKey: refreshTokenKey)
        } else {
            valet.removeObject(forKey: refreshTokenKey)
        }
    }
}
