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
        let typesToSync: Set = [
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)! ]
        
        if HKHealthStore.isHealthDataAvailable() {
            healthStore.requestAuthorization(toShare: typesToSync, read: typesToSync) { (success, error) in
                if !success {
                    print("HealthKit Authorization Process Failed.")
                    return
                }
                // Save result's bmi value to HealthKit
                if let bmiToSave = self.bmi?.value {
                    self.saveBMI(bmiRecorded: Double(bmiToSave), date: self.date)
                }
            }
        }
        
    }
    
    func saveBMI(bmiRecorded: Double, date: Date) {
        // create HKQuatity type object with unit compatible to HealthKit's BMI unit
        let bmiType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)
        let bmiQuatity = HKQuantity(unit: HKUnit.count(), doubleValue: bmiRecorded)
        let bmi = HKQuantitySample(type: bmiType!, quantity: bmiQuatity, start: date, end: date)
        
        healthStore.save(bmi) { (success, error) in
            if error != nil {
                // present error message to user
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Cannot save BMI data to Health App. Please check settings and make sure 'BMI App' has proper access to Health database.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                        // no action after user clicks 'OK' button
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                
                print("Error saving data to HealthKit.")
                print(error.debugDescription)
            } else {
                // present success message to user
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Done", message: "Calculated BMI has been saved to HealthKit.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                
                print("The bmi has been recorded!")
            }
        }
    }
    
}
