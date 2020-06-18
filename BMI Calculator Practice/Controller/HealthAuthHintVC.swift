//
//  HealthAuthHintVC.swift
//  BMI Calculator Practice
//
//  Created by Jason Ou Yang on 2020/6/18.
//  Copyright © 2020 Jason Ou Yang. All rights reserved.
//

import UIKit
import HealthKit

class HealthAuthHintVC: UIViewController {

    let healthStore = HKHealthStore()
    let resultVC = ResultViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //User pressed 'OK' button
    @IBAction func okBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.resultVC.requestHKAuth()
        }
        
//        let typesToSync: Set = [
//            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)! ]
//
//        if HKHealthStore.isHealthDataAvailable() {
//            healthStore.requestAuthorization(toShare: typesToSync, read: typesToSync) { (success, error) in
//                if !success {
//                    print("HealthKit Authorization Process Failed.")
//                    return
//                }
//
//            }
//        }
    }
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
