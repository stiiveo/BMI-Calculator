//
//  BMI_Calculator_PracticeTests.swift
//  BMI Calculator PracticeTests
//
//  Created by Jason Ou Yang on 2020/6/19.
//  Copyright © 2020 Jason Ou Yang. All rights reserved.
//

@testable import BMI_Calculator_Practice
import XCTest

class BMI_Calculator_PracticeTests: XCTestCase {
    
    var homeVC: HomeViewController!
    var textField: CustomTextField!

    override func setUpWithError() throws {
        try super.setUpWithError()
        textField = CustomTextField()
        homeVC = HomeViewController()
        homeVC.loadView()
        textField.delegate = homeVC
    }

    override func tearDownWithError() throws {
        textField = nil
        homeVC = nil
        try super.tearDownWithError()
    }

    func testTextFieldAutoClearing() {
        textField.text = "Text to be cleared"
        textField.becomeFirstResponder()
        
        if textField.isFirstResponder {
            XCTAssertTrue(textField.text == "")
        }
    }
    
    func testAutoAdditionOfZeroBeforeDot() {
        for _ in 1..<100 {
            textField.text = ""
            
            guard let shouldChangeCharacters = textField.delegate?.textField?(textField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: ".") else {
                print("Failed to get the status of textField's delegation")
                return
            }
            if shouldChangeCharacters {
                textField.text!.append(".")
            }
            
            XCTAssert(textField.text == "0" + ".")
        }
    }
    
    func testValueIsOnlyWithinThreeDigits() {
        for _ in 0..<100 {
            textField.text = ""
            
            for _ in 0..<6 {
                let randomCharacter = String(Int.random(in: 0...9))
                let inputLocation = textField.text!.count
                
                guard let shouldChangeCharacter = textField.delegate?.textField?(textField, shouldChangeCharactersIn: NSRange(location: inputLocation, length: 0), replacementString: randomCharacter) else {
                    print("Failed to get the status of textField's delegation")
                    break
                }
                
                if shouldChangeCharacter {
                    textField.text?.append(randomCharacter)
                }
            }
            
            XCTAssert(Double(textField.text!)! < 1000)
        }
    }
    
    //    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}

