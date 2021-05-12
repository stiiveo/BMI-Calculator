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
        _ = validateInput()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let validatedInput = validateInput() {
            calculatedBmi = BmiCalculator().calculateBMI(heightInCentimeter: validatedInput.height, weightInKg: validatedInput.weight)
            performSegue(withIdentifier: SegueIdentifier.goToResultView.rawValue, sender: self)
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
            _ = validateInput()
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
    
    // MARK: - Input Validation & Hint Label Methods
    
    struct ValidInput {
        var height: Double
        var weight: Double
    }
    
    private func validateInput() -> ValidInput? {
        do {
            let validatedHeight = try heightTextField.validated(byValidator: .height)
            let validatedWeight = try weightTextField.validated(byValidator: .weight)
            hintLabel.text = ""
            return ValidInput(height: validatedHeight, weight: validatedWeight)
        } catch ValidationError.emptyField {
            hintLabel.text = Strings.localizedString(key: .emptyField)
        } catch ValidationError.zeroValue {
            hintLabel.text = Strings.localizedString(key: .valueZeroDetected)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

// MARK: - TextField Input Manipulation

extension HomeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            // Add character 0 if the first input is '.'
            if text.isEmpty && string == "." {
                textField.text = "0"
            }
            
            // Allow only one dot character in text field
//            if text.contains(".") && string == "." {
//                return false
//            }
            
            // Value can not be bigger than 999
            if let newValue = Double(text + string) {
                if newValue > 999 && string != "" {
                    return false
                }
            }
            
            // Remove first 0 character if there's any
            if text.count == 1 && text == "0" && string != "." {
                textField.text = ""
            }
            
            // Limit the maximum character allowed
            if text.count + string.count > 6 {
                print("character count will be > 6")
                return false
            }
            
            // Allow only one decimal point and place
            let text = text as NSString
            let candidate = text.replacingCharacters(in: range, with: string)
            let regex = try? NSRegularExpression(pattern: "^\\d{0,4}(\\.\\d?)?$", options: [])
            return regex?.firstMatch(in: candidate, options: [], range: NSRange(location: 0, length: candidate.count)) != nil
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.clearsOnBeginEditing = true
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
