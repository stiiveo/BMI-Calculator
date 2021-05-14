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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

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
        if let validatedInput = validateInput() {
            calculatedBmi = BmiCalculator().calculateBMI(heightInCentimeter: validatedInput.height, weightInKg: validatedInput.weight)
            performSegue(withIdentifier: SegueIdentifier.goToResultView.identifier, sender: self)
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
            _ = validateInput()
        }
    }
    
    // MARK: - Input Validation & Hint Label
    
    struct ValidInput {
        var height: Double
        var weight: Double
    }
    
    private func validateInput() -> ValidInput? {
        do {
            let validatedHeight = try heightTextField.validated(byValidator: .height)
            let validatedWeight = try weightTextField.validated(byValidator: .weight)
            hintLabel.updateLabelText(hint: .none)
            return ValidInput(height: validatedHeight, weight: validatedWeight)
        } catch ValidationError.emptyField {
            hintLabel.updateLabelText(hint: .emptyField)
        } catch ValidationError.zeroValue {
            hintLabel.updateLabelText(hint: .zeroValue)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
}

class CustomTextField: UITextField {
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // Disable all available actions: Copy, Paste, Cut, etc.
        return false
    }
}
