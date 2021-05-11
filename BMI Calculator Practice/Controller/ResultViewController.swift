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
    
    private let bmiQuantityType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)
    private let healthKitManager = HealthKitManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up BMI label, advice label and background color
        bmiLabel.text = String(format: "%.1f", calculatedBmi.value)
        adviceLabel.text = calculatedBmi.advice
        self.view.backgroundColor = calculatedBmi.color
        
        // Make buttons' background corners rounded
        saveToHealthBtn.layer.cornerRadius = 10
        recalculateBtn.layer.cornerRadius = 10
        saveToHealthBtn.isEnabled = healthKitManager.dataIsAvailable
    }
    
    @IBAction func recalculateBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func healthKitSyncBtnPressed(_ sender: UIButton) {
        let authStatus = healthKitManager.authStatus
        switch authStatus {
        case .notDetermined, .sharingDenied:
            // Go To HealthKit Auth Request View
            performSegue(withIdentifier: SegueIdentifier.goToAuthView.rawValue, sender: self)
        case .sharingAuthorized:
            healthKitManager.saveCalculatedValue { (success) in
                guard success else {
                    self.presentErrorAlert()
                    return
                }
                self.presentDoneAlert()
            }
        @unknown default:
            debugPrint("Unknown case of HealthKit auth status is encountered: \(authStatus)")
        }
    }
    
    private func presentDoneAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: Strings.localizedString(key: .successTitle), message: Strings.localizedString(key: .successMessage), preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func presentErrorAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: Strings.localizedString(key: .healthKitErrorTitle), message: Strings.localizedString(key: .healthKitErrorMessage), preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
