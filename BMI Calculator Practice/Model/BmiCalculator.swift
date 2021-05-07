//
//  BmiCalculator.swift
//  BMI Calculator Practice
//
//  Created by Jason Ou Yang on 2020/5/29.
//  Copyright © 2020 Jason Ou Yang. All rights reserved.
//

import UIKit

struct BmiCalculator {
    
    func calculateBMI(heightInCentimeter: Double, weightInKg: Double) -> BMI {
        // BMI = Weight(kg) / ( Height(m) )^2
        let heightInMeter = heightInCentimeter / 100
        let bmiValue = weightInKg / pow(heightInMeter, 2)
        
        if bmiValue < 18.5 {
            return BMI(value: bmiValue, advice: Strings.underweightAdvice, color: #colorLiteral(red: 0.5261438516, green: 0.761373409, blue: 0.9686274529, alpha: 1))
        } else if bmiValue < 25.0 {
            return BMI(value: bmiValue, advice: Strings.normalWeightAdvice, color: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
        } else if bmiValue < 30.0 {
            return BMI(value: bmiValue, advice: Strings.overweightAdvice, color: #colorLiteral(red: 0.9458907247, green: 0.4696775079, blue: 0.03574030846, alpha: 1))
        } else {
            return BMI(value: bmiValue, advice: Strings.obesityAdvice, color: #colorLiteral(red: 0.9060729146, green: 0.07904083282, blue: 0.07782957703, alpha: 1))
        }
    }
}
