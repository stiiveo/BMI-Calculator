//
//  HomeViewController.swift
//  BMI Calculator Practice
//
//  Created by Jason Ou Yang on 2020/5/28.
//  Copyright © 2020 Jason Ou Yang. All rights reserved.
//

protocol HomeVCDelegate {
    var heightTextField: CustomTextField! { get }
}

import UIKit

class HomeViewController: UIViewController, HomeVCDelegate {

    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightTextField: CustomTextField!
    @IBOutlet weak var weightTextField: CustomTextField!
    @IBOutlet weak var calculateBtn: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightLabel.text = Strings.localizedString(key: .heightLabel)
        weightLabel.text = Strings.localizedString(key: .weightLabel)
        heightTextField.delegate = self
        weightTextField.delegate = self
        calculateBtn.layer.cornerRadius = 10
        hintLabel.text = ""
        
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
        do {
            let validatedHeight = try heightTextField.validated(byValidator: .height)
            let validatedWeight = try weightTextField.validated(byValidator: .weight)
            
            calculatedBmi = BmiCalculator().calculateBMI(heightInCentimeter: validatedHeight, weightInKg: validatedWeight)
            performSegue(withIdentifier: SegueIdentifier.goToResultView.rawValue, sender: self)
            hintLabel.text = ""
        } catch ValidationError.emptyField {
            hintLabel.text = Strings.localizedString(key: .emptyField)
            
        } catch ValidationError.zeroValue {
            hintLabel.text = Strings.localizedString(key: .valueZeroDetected)
            
        } catch let ValidationError.message(message) {
            print(message)
            
        } catch {
            print("Failed to get validated input values: \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ResultViewController {
            destinationVC.delegate = self
        }
    }
    
    // MARK: - Toolbar Customization
    
    private func addBarButtonToKeyboard() {
        heightTextField.inputAccessoryView = toolbar(withButtonTitled: Strings.localizedString(key: .buttonNext))
        weightTextField.inputAccessoryView = toolbar(withButtonTitled: Strings.localizedString(key: .buttonDone))
    }
    
    private func toolbar(withButtonTitled title: String) -> UIToolbar {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        toolbar.sizeToFit()

        // Accessory item
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(barButtonAction))

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

// MARK: - TextField Input Manipulation

extension HomeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text {
            
            // Add character 0 if the first input is 0
            if text.isEmpty && string.contains(".") {
                textField.text = "0"
            }
            
            // Allow only one dot character in text field
            if text.contains(".") && string.contains(".") {
                return false
            }
            
            // Values can not be bigger than 1000
            if let currentValue = Double(text) {
                if currentValue >= 999 && string != "" {
                    return false
                }
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Select all of the text field's content if it's not empty
        if let text = textField.text {
            if !text.isEmpty {
                textField.selectAll(self)
            }
        }
    }
}

class CustomTextField: UITextField {
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // Disable all available actions: Copy, Paste, Cut, etc.
        return false
    }
}

extension CustomTextField {
    func validated(byValidator validatorType: ValidatorType) throws -> Double {
        let validator = ValidatorFactory.validator(forType: validatorType)
        return try validator.validated(self.text)
    }
}
