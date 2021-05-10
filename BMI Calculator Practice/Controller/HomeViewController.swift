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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightLabel.text = Strings.heightLabel
        weightLabel.text = Strings.weightLabel
        calculateBtn.layer.cornerRadius = 10
        
        // Look for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        // Uncomment the line below if you want the tap not interfere and cancel other interactions.
//        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        addBarButtonToKeyboard()
        
        // Add keyboard observor to adjust view's y position accordingly.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard !heightTextField.text!.isEmpty && !weightTextField.text!.isEmpty else { return }
        
        if let heightString = heightTextField.text,
           let weightString = weightTextField.text {
            
            if let heightDoubleValue = Double(heightString),
               let weightDouble = Double(weightString) {
                calculatedBmi = BmiCalculator().calculateBMI(heightInCentimeter: heightDoubleValue, weightInKg: weightDouble)
                performSegue(withIdentifier: "goToResult", sender: self)
            }
        }
    }
    
    private enum ButtonFunction: String {
        case next = "Next", done = "Done"
    }
    
    private func addBarButtonToKeyboard() {
        heightTextField.inputAccessoryView = toolbar(withButton: .next)
        weightTextField.inputAccessoryView = toolbar(withButton: .done)
    }
    
    private func toolbar(withButton button: ButtonFunction) -> UIToolbar {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        toolbar.sizeToFit()

        // Accessory item
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: button.rawValue, style: .plain, target: self, action: #selector(barButtonAction))

        toolbar.items = [flexSpace, barButton]
        return toolbar
    }

    @objc func barButtonAction() {
        if heightTextField.isFirstResponder {
            weightTextField.becomeFirstResponder()
        } else {
            weightTextField.resignFirstResponder()
        }
    }
    
    // MARK: - View Position Adjustment
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 6
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
