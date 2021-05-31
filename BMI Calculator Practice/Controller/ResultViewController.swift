//
//  ResultViewController.swift
//  BMI Calculator Practice
//
//  Created by Jason Ou Yang on 2020/5/29.
//  Copyright © 2020 Jason Ou Yang. All rights reserved.
//

import UIKit
import HealthKit

// Only classes are allowed to conform to this protocol.
protocol HomeVCDelegate: AnyObject {
    var heightTextField: CustomTextField! { get }
    var weightTextField: CustomTextField! { get }
}

class ResultViewController: UIViewController {
    
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var saveToHealthButton: UIButton!
    @IBOutlet weak var recalculateButton: UIButton!
    
    private let BMIQuantityType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)
    private let healthKitManager = HealthKitManager()
    weak var delegate: HomeVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Round the calculated BMI value to the first decimal place using schoolbook rule.
        let BMIValue = (calculatedBMI.value * 10).rounded() / 10
        bmiLabel.text = String(BMIValue)
        adviceLabel.text = calculatedBMI.advice
        self.view.backgroundColor = calculatedBMI.color
        
        // Round each UI button's corners.
        saveToHealthButton.layer.cornerRadius = 10
        recalculateButton.layer.cornerRadius = 10
        saveToHealthButton.isEnabled = healthKitManager.dataIsAvailable
    }
    
    @IBAction func recalculateBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.heightTextField?.becomeFirstResponder()
            self.delegate?.weightTextField?.text = ""
        }
    }
    
    @IBAction func healthKitSyncBtnPressed(_ sender: UIButton) {
        let authStatus = healthKitManager.authStatus
        switch authStatus {
        case .notDetermined, .sharingDenied:
            performSegue(withIdentifier: SegueIdentifier.goToAuthView.identifier, sender: self)
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
