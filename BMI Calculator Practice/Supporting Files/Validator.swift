//
//  Validator.swift
//  BMI Calculator Practice
//
//  Created by Jason Ou Yang on 2021/5/11.
//  Copyright © 2021 Jason Ou Yang. All rights reserved.
//

import UIKit

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
    case other(String)
}

final class Validator: ValidatorConvertible {
    
    /// Returns `Double` value created from the provided `String` value once it passes the validation process.
    /// - Parameter string: String value to be validated.
    /// - Throws: A custom error type object `ValidationError` could be thrown if the provided string value did not pass the validation process.
    /// - Returns: The `Double` value created from validated string value.
    func validated(_ string: String?) throws -> Double {
        
        guard let string = string else {
            throw ValidationError.other("Provided.")
        }
        
        guard !string.isEmpty else {
            throw ValidationError.emptyField
        }
        
        guard let valueCreatedFromString = Double(string) else {
            throw ValidationError.other("Failed to get valid double values from either text field.")
        }
        
        guard valueCreatedFromString != 0 else {
            throw ValidationError.zeroValue
        }
        
        // Return validated value
        return valueCreatedFromString
    }
}

extension HomeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.clearsOnBeginEditing = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text {
            // Add character 0 if the first input is '.'
            if text.isEmpty && string == "." {
                textField.text = "0"
            }
            
            // Value can not be bigger than 999
            if let newValue = Double(text + string) {
                if newValue > 999 && string != "" {
                    return false
                }
            }
            
            // Remove first 0 character if there's any
            if text.count == 1 && text == "0" && string != "." {
                textField.text = ""
            }
            
            // Limit the maximum character allowed
            if text.count + string.count > 6 {
                print("character count will be > 6")
                return false
            }
            
            // Allow total 5 characters with utmost one decimal point and place
            let text = text as NSString
            let candidate = text.replacingCharacters(in: range, with: string)
            let regex = try? NSRegularExpression(pattern: "^\\d{0,4}(\\.\\d{0,1})?$", options: [])
            return regex?.firstMatch(in: candidate, options: [], range: NSRange(location: 0, length: candidate.count)) != nil
        }
        
        return true
    }
    
}
