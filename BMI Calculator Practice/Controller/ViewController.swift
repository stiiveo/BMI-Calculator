//
//  inputViewController.swift
//  BMI Calculator Practice
//
//  Created by Jason Ou Yang on 2020/5/28.
//  Copyright © 2020 Jason Ou Yang. All rights reserved.
//

import UIKit

class inputViewController: UIViewController {

    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    var bmiCalculator = BmiCalculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func heightAdjusted(_ sender: UISlider) {
        heightLabel.text = String(format: "%.0f", sender.value) + " cm"
    }
    
    @IBAction func weightAdjusted(_ sender: UISlider) {
        weightLabel.text = String(format: "%.0f", sender.value) + " kg"
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        let height = heightSlider.value
        let weight = weightSlider.value
        bmiCalculator.calculateBMI(height: height, weight: weight)
        
        performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ResultViewController
        if segue.identifier == "goToResult" {
            destinationVC.bmi = bmiCalculator.bmi
        }
    }
}

