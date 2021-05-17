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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = Strings.localizedString(key: .authTitle)
        messageLabel.text = Strings.localizedString(key: .authMessage)
        okBtn.setTitle(Strings.localizedString(key: .authOKButton), for: .normal)
        skipBtn.setTitle(Strings.localizedString(key: .authSkipButton), for: .normal)
        okBtn.layer.cornerRadius = okBtn.frame.height / 4
    }
    
    private let healthKitManager = HealthKitManager()
    
    @IBAction func okBtnPressed(_ sender: UIButton) {
        healthKitManager.requestHKAuth { success in
            guard success else {
                return
            }
            // Authorized to write BMI data to Health Kit store
            self.saveDataToHKStore()
        }
    }
    
    private func saveDataToHKStore() {
        healthKitManager.saveCalculatedValue { success in
            guard success else {
                self.presentErrorAlert()
                return
            }
            self.presentSuccessAlert()
        }
    }
    
    private func presentSuccessAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: Strings.localizedString(key: .successTitle), message: Strings.localizedString(key: .successMessage), preferredStyle: .alert)
            let action = UIAlertAction(title: Strings.localizedString(key: .authOKButton), style: .default) { _ in
                // Data is saved to the store
                self.dismiss(animated: true)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func presentErrorAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: Strings.localizedString(key: .authErrorTitle), message: Strings.localizedString(key: .authErrorMessage), preferredStyle: .alert)
            let action = UIAlertAction(title: Strings.localizedString(key: .authOKButton), style: .default) { _ in }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
