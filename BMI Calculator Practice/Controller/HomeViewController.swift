//
//  HomeViewController.swift
//  BMI Calculator Practice
//
//  Created by Jason Ou Yang on 2020/5/28.
//  Copyright © 2020 Jason Ou Yang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var calculateBtn: UIButton!
    
    var bmiCalculator = BmiCalculator()
    var strings = Strings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // heightLabel's text = slider's current value + localized unit
        heightLabel.text = String(format: "%.0f", heightSlider.value) + strings.lengthUnit
        
        // weightLabel's text = slider's current value + localized unit
        weightLabel.text = String(format: "%.0f", weightSlider.value) + strings.weightUnit
        
        // Make 'Calculate button's rounded
        calculateBtn.layer.cornerRadius = 10
    }

    @IBAction func heightAdjusted(_ sender: UISlider) {
        heightLabel.text = String(format: "%.0f", sender.value) + strings.lengthUnit
    }
    
    @IBAction func weightAdjusted(_ sender: UISlider) {
        weightLabel.text = String(format: "%.0f", sender.value) + strings.weightUnit
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let height = heightSlider.value
        let weight = weightSlider.value
        
        bmiCalculator.calculateBMI(heightInCentimeter: height, weight: weight)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            // Send calculated BMI info to ResultVC
            destinationVC.bmi = bmiCalculator.bmi
        }
    }
}

