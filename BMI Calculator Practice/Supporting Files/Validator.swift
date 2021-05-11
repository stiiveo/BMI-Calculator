//
//  Validator.swift
//  BMI Calculator Practice
//
//  Created by Jason Ou Yang on 2021/5/11.
//  Copyright © 2021 Jason Ou Yang. All rights reserved.
//

import Foundation

protocol ValidatorConvertible {
    func validated(_ value: String?) throws -> Double
}

enum ValidatorType {
    case height, weight
}

enum ValidatorFactory {
    static func validator(forType type: ValidatorType) -> ValidatorConvertible {
        switch type {
        // Different validator can be returned based on provided validator type
        case .height: return Validator()
        case .weight: return Validator()
        }
    }
}

enum ValidationError: Error {
    case emptyField, zeroValue
    case message(String)
}

class Validator: ValidatorConvertible {
    
    func validated(_ value: String?) throws -> Double {
        
        guard let value = value else {
            throw ValidationError.message("Failed to retrieve string value from either text field.")
        }
        
        guard !value.isEmpty else {
            throw ValidationError.emptyField
        }
        
        guard let doubleValue = Double(value) else {
            throw ValidationError.message("Failed to get valid double values from either text field.")
        }
        
        guard doubleValue != 0 else {
            throw ValidationError.zeroValue
        }
        
        return Double(value)!
    }
}
