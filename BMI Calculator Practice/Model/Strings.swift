//
//  Strings.swift
//  BMI Calculator Practice
//
//  Created by Jason Ou Yang on 2020/6/8.
//  Copyright © 2020 Jason Ou Yang. All rights reserved.
//

import Foundation

struct Strings {
    
    struct SegueIdentifier {
        static let goToResultView = "goToResult"
        static let goToAuthView = "goToAuthHint"
    }
    
    
    struct LocalizationKey {
        
        static let heightLabel = "HEIGHT_LABEL"
        static let weightLabel = "WEIGHT_LABEL"
        static let underweightAdvice = "ADVICE_UNDERWEIGHT"
        static let normalWeightAdvice = "ADVICE_NORMAL"
        static let overweightAdvice = "ADVICE_OVERWEIGHT"
        static let obesityAdvice = "ADVICE_OBESITY"
        static let authErrorTitle = "AUTH_ERROR_TITLE"
        static let authErrorMessage = "AUTH_ERROR_MESSAGE"
        static let successTitle = "SUCCESS_TITLE"
        static let successMessage = "SUCCESS_MESSAGE"
        static let healthKitErrorTitle = "HEALTHKIT_ERROR_TITLE"
        static let healthKitErrorMessage = "HEALTHKIT_ERROR_MESSAGE"
        static let emptyInput = "EMPTY_INPUT"
        static let valueZeroDetected = "ZERO_INPUT"
        
    }
        
    static func localizedString(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
