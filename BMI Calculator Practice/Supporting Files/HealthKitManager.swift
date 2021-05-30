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
    private let BMIQuantityType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)!
    
    var dataIsAvailable: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    var authStatus: HKAuthorizationStatus {
        return healthStore.authorizationStatus(for: BMIQuantityType)
    }
    
    func requestHKAuth(completion: @escaping authCompletion) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            print("HealthKit not available")
            return
        }
        
        let typesToSync: Set = [ BMIQuantityType ]
        healthStore.requestAuthorization(toShare: typesToSync, read: nil) { (success, error) in
            guard error == nil else {
                completion(false)
                print("Failed to get HealthKit authorization.")
                return
            }
            completion(true)
        }
    }
    
    func saveCalculatedValue(completion: @escaping syncCompletion) {
        saveData(dataType: BMIQuantityType, withValue: calculatedBMI.value) { success in
                guard success else {
                    completion(false)
                    return
                }
                completion(true)
        }
    }
    
    private func saveData(dataType: HKQuantityType, withValue value: Double, completion: @escaping syncCompletion) {
        // Create HKQuantity type object with unit compatible to HealthKit's BMI unit
        let BMIQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: value)
        let hKSample = HKQuantitySample(type: dataType, quantity: BMIQuantity, start: Date(), end: Date())
        
        healthStore.save(hKSample) { (success, error) in
            
            guard error == nil else {
                completion(false)
                print("Error saving object to HealthKit: \(error!.localizedDescription)")
                return
            }
            
            completion(true)
            print("Object with type \(dataType) and value \(value) had been saved to HealthKit store.")
        }
        
    }
}
