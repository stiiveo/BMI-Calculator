//
//  BMICalculator.swift
//  BMI Calculator Practice
//
//  Created by Jason Ou Yang on 2020/5/29.
//  Copyright © 2020 Jason Ou Yang. All rights reserved.
//

import UIKit

var calculatedBMI = BMI(value: 0, advice: "", color: .black)

struct BMICalculator {
    
    func calculateBMI(heightInCentimeter: Double, weightInKg: Double) -> BMI {
        // BMI = Weight(kg) / ( Height(m) )^2
        let heightInMeter = heightInCentimeter / 100
        let BMI = weightInKg / pow(heightInMeter, 2)
        
        if BMI < 18.5 {
            return BMI(value: BMI, advice: Strings.localizedString(key: .underweightAdvice), color: #colorLiteral(red: 0.5261438516, green: 0.761373409, blue: 0.9686274529, alpha: 1))
        } else if BMI < 25.0 {
            return BMI(value: BMI, advice: Strings.localizedString(key: .normalWeightAdvice), color: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
        } else if BMI < 30.0 {
            return BMI(value: BMI, advice: Strings.localizedString(key: .overweightAdvice), color: #colorLiteral(red: 0.9458907247, green: 0.4696775079, blue: 0.03574030846, alpha: 1))
        } else {
            return BMI(value: BMI, advice: Strings.localizedString(key: .obesityAdvice), color: #colorLiteral(red: 0.9060729146, green: 0.07904083282, blue: 0.07782957703, alpha: 1))
        }
    }
}
