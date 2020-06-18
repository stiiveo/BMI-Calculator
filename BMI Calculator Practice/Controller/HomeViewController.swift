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
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var calculateBtn: UIButton!
    
    var bmiCalculator = BmiCalculator()
    let labels = Strings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightLabel.text = labels.heightLabel
        weightLabel.text = labels.weightLabel
        
        // Make 'Calculate button's rounded
        calculateBtn.layer.cornerRadius = 10
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if !heightTextField.text!.isEmpty && !weightTextField.text!.isEmpty {
            if let heightString = heightTextField.text,
                let weightString = weightTextField.text {
                if let heightDoubleValue = Double(heightString),
                    let weightDouble = Double(weightString) {

                    //Calculate BMI with textfields' current value and store the result at BMICalculator's var bmi
                    bmiCalculator.calculateBMI(heightInCentimeter: heightDoubleValue, weight: weightDouble)
                    
                    performSegue(withIdentifier: "goToResult", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            // Send calculated BMI info to ResultVC
            destinationVC.bmi = bmiCalculator.bmi
        }
    }
}
