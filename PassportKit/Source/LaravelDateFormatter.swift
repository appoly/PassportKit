//
//  LaravelDateFormatter.swift
//  PassportKit
//
//  Created by James Wolfe on 25/02/2020.
//  Copyright © 2020 Appoly. All rights reserved.
//



import Foundation



class AppolyDateFormatter: DateFormatter {
    
    // MARK: - Variables
    
    let format = "yyyy-MM-dd HH:mm:ss"
    
    
    
    // MARK: - Initializer
    
    override init() {
        super.init()
        
        calendar = Calendar.autoupdatingCurrent
        locale = Locale.autoupdatingCurrent
        timeZone = TimeZone.autoupdatingCurrent
        dateFormat = format
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
