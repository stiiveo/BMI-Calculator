//
//  Extensions.swift
//  BMI Calculator Practice
//
//  Created by Jason Ou Yang on 2021/5/14.
//  Copyright © 2021 Jason Ou Yang. All rights reserved.
//

import UIKit

extension CustomTextField {
    func validated(byValidator validatorType: ValidatorType) throws -> Double {
        let validator = ValidatorFactory.validator(forType: validatorType)
        return try validator.validated(self.text)
    }
}

extension UILabel {
    enum LabelHint {
       case emptyField, zeroValue, none
    }
    
    func updateLabelText(hint: LabelHint) {
        switch hint {
        case .emptyField: self.text = Strings.localizedString(key: .emptyField)
        case .zeroValue: self.text = Strings.localizedString(key: .valueZeroDetected)
        case .none: self.text = ""
        }
    }
}
