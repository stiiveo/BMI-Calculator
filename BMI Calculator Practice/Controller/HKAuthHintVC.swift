//
//  HKAuthHintVC.swift
//  BMI Calculator Practice
//
//  Created by Jason Ou Yang on 2020/6/18.
//  Copyright © 2020 Jason Ou Yang. All rights reserved.
//

import UIKit
import HealthKit

class HKAuthHintVC: UIViewController {

    @IBOutlet weak var okBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okBtn.layer.cornerRadius = 20
    }
    
    private let healthKitManager = HealthKitManager()
    
    @IBAction func okBtnPressed(_ sender: UIButton) {
        healthKitManager.requestHKAuth { success in
            guard success else {
                return
            }
            
            // Authorized to write BMI data to Health Kit store
            self.healthKitManager.saveDataToHKStore { success in
                guard success else {
                    self.presentErrorAlert()
                    return
                }
                self.presentSuccessAlert()
            }
        }
    }
    
    private func presentSuccessAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: Strings.successTitle, message: Strings.successMessages, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                // Data is saved to the store
                self.dismiss(animated: true)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func presentErrorAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: Strings.errorTitle, message: Strings.errorMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}