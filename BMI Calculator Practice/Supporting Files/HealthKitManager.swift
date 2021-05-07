//
//  HealthKitManager.swift
//  BMI Calculator Practice
//
//  Created by Jason Ou Yang on 2021/5/7.
//  Copyright © 2021 Jason Ou Yang. All rights reserved.
//

import Foundation
import HealthKit

typealias authCompletion = (Bool) -> Void
typealias syncCompletion = (Bool) -> Void

struct HealthKitManager {
    
    private let healthStore = HKHealthStore()
    private let bmiQuantityType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)
    
    var dataIsAvailable: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    var authStatus: HKAuthorizationStatus {
        return healthStore.authorizationStatus(for: bmiQuantityType!)
    }
    
    func requestHKAuth(completion: @escaping authCompletion) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            print("HealthKit not available")
            return
        }
        
        let typesToSync: Set = [ bmiQuantityType! ]
        healthStore.requestAuthorization(toShare: typesToSync, read: nil) { (success, error) in
            guard error == nil else {
                completion(false)
                print("Failed to get HealthKit authorization.")
                return
            }
            completion(true)
        }
    }
    
    func saveDataToHKStore(completion: @escaping syncCompletion) {
        // Create HKQuatity type object with unit compatible to HealthKit's BMI unit
        let bmiQuatity = HKQuantity(unit: HKUnit.count(), doubleValue: calculatedBmi.value)
        let hKSample = HKQuantitySample(type: bmiQuantityType!, quantity: bmiQuatity, start: Date(), end: Date())
        
        healthStore.save(hKSample) { (success, error) in
            
            guard error == nil else {
                print("Error saving data to Health Kit: \(error!.localizedDescription)")
                completion(false)
                return
            }
            
            completion(true)
            print("BMI data has been saved to Health App!")
        }
        
    }
}
