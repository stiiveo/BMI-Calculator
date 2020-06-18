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
    }
    
    //User pressed 'Cancel' button
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
