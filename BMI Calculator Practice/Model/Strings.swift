//
//  Strings.swift
//  BMI Calculator Practice
//
//  Created by Jason Ou Yang on 2020/6/8.
//  Copyright © 2020 Jason Ou Yang. All rights reserved.
//

import Foundation

enum SegueIdentifier {
    case goToResultView
    case goToAuthView
    
    var identifier: String {
        switch self {
        case .goToResultView: return "goToResult"
        case .goToAuthView: return "goToAuthHint"
        }
    }
}

struct Strings {
    
    enum LocalizationKey: String {
        
        case heightLabel = "HEIGHT_LABEL"
        case weightLabel = "WEIGHT_LABEL"
        case underweightAdvice = "ADVICE_UNDERWEIGHT"
        case normalWeightAdvice = "ADVICE_NORMAL"
        case overweightAdvice = "ADVICE_OVERWEIGHT"
        case obesityAdvice = "ADVICE_OBESITY"
        case authErrorTitle = "AUTH_ERROR_TITLE"
        case authErrorMessage = "AUTH_ERROR_MESSAGE"
        case successTitle = "SUCCESS_TITLE"
        case successMessage = "SUCCESS_MESSAGE"
        case healthKitErrorTitle = "HEALTHKIT_ERROR_TITLE"
        case healthKitErrorMessage = "HEALTHKIT_ERROR_MESSAGE"
        case emptyField = "EMPTY_INPUT"
        case valueZeroDetected = "ZERO_INPUT"
        case buttonNext = "BUTTON_NEXT"
        case buttonDone = "BUTTON_DONE"
        case authTitle = "AUTH_TITLE"
        case authMessage = "AUTH_MESSAGE"
        case authOKButton = "AUTH_OK_BUTTON"
        case authSkipButton = "AUTH_SKIP_BUTTON"
        
    }
        
    static func localizedString(key: LocalizationKey) -> String {
        return NSLocalizedString(key.rawValue, comment: "")
    }
}
