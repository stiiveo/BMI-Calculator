//
//  ResultViewController.swift
//  BMI Calculator Practice
//
//  Created by Jason Ou Yang on 2020/5/29.
//  Copyright © 2020 Jason Ou Yang. All rights reserved.
//

import UIKit
import HealthKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var saveToHealthBtn: UIButton!
    @IBOutlet weak var recalculateBtn: UIButton!
    
    var bmi: BMI?
    let healthStore = HKHealthStore()
    let date = Date()
    let messages = Strings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set BMI, advice label values and background color
        if let bmiResult = bmi {
            bmiLabel.text = String(format: "%.1f", bmiResult.value)
            adviceLabel.text = bmiResult.advice
            self.view.backgroundColor = bmiResult.color
        }
        // Make buttons' background corners rounded
        saveToHealthBtn.layer.cornerRadius = 10
        recalculateBtn.layer.cornerRadius = 10
    }
    
    @IBAction func recalculateBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func healthKitSyncBtnPressed(_ sender: UIButton) {
        
        if let typeToSync = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex) {
            let authStatus = healthStore.authorizationStatus(for: typeToSync)
            
            if authStatus.rawValue != 2 {
                //if authorization status = case notDetermined or sharingDenied
                performSegue(withIdentifier: "goToAuthHint", sender: self)
            } else {
                //if authorization status = case sharingAuthorized
                saveBmiToHK()
            }
        }
    }
    
    func requestHKAuth() {
        let typesToSync: Set = [
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)! ]
        
        if HKHealthStore.isHealthDataAvailable() {
            healthStore.requestAuthorization(toShare: typesToSync, read: nil) { (success, error) in
                if !success {
                    print("HealthKit Authorization Process Failed.")
                    return
                }
                // Save result's bmi value to HealthKit
                self.saveBmiToHK()
            }
        }
    }
    
    func saveBmiToHK() {
        if let bmiToSync = bmi?.value {
            // create HKQuatity type object with unit compatible to HealthKit's BMI unit
            let bmiType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)
            let bmiQuatity = HKQuantity(unit: HKUnit.count(), doubleValue: bmiToSync)
            let bmi = HKQuantitySample(type: bmiType!, quantity: bmiQuatity, start: date, end: date)

            healthStore.save(bmi) { (success, error) in
                if error != nil {
                    // present error message to user
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: self.messages.errorTitle, message: self.messages.errorMessage, preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default) { (action) in
                            // no action after user clicks 'OK' button
                        }
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                    print("Error saving data to HealthKit.")
                    print(error.debugDescription)
                } else {
                    print("check B")
                    // present success message to user
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: self.messages.successTitle, message: self.messages.successMessages, preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default) { (action) in
                            // no action after user clicks 'OK' button
                        }
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    print("The bmi has been recorded!")
                }
            }
        }
    }
    
}

extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }

    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}
