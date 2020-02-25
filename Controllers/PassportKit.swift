//
//  PassportKit.swift
//  PassportKit
//
//  Created by James Wolfe on 25/02/2020.
//  Copyright © 2020 Appoly. All rights reserved.
//


import Foundation



public struct PassportConfiguration {
    let baseURL: URL!
    let clientID: String!
    let clientSecret: String!
    let keychainID: String!
}



class PassportKit: NSObject {
    
    // MARK: - Variables
    
    let configuration: PassportConfiguration!
    let delegate: PassportViewDelegate!
    
    
    
    // MARK: - Initializers
    
    init(_ configuration: PassportConfiguration, delegate: PassportViewDelegate) {
        self.configuration = configuration
        self.delegate = delegate
        super.init()
    }
    
    
    
    // MARK: - Utilities
    
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
    
}
