//
//  TextFieldValidatingTests.swift
//  BMI Calculator PracticeTests
//
//  Created by Jason Ou Yang on 2020/6/19.
//  Copyright © 2020 Jason Ou Yang. All rights reserved.
//

@testable import BMI_Calculator_Practice
import XCTest

class TextFieldValidatingTests: XCTestCase {
    
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
            if let shouldChangeCharacter = shouldTextFieldChangeCharacters(textField: textField, range: NSRange(location: 0, length: 0), newString: ".") {
                if shouldChangeCharacter {
                    textField.text!.append(".")
                }
            }
            
            XCTAssert(textField.text == "0" + ".")
        }
    }
    
    func testValueIsOnlyWithinThreeDigits() {
        for _ in 0..<100 {
            textField.text = ""
            
            for _ in 0..<7 {
                let randomCharacter = String(Int.random(in: 0...9))
                let inputLocation = textField.text!.count
                
                if let shouldChangeCharacter = shouldTextFieldChangeCharacters(
                    textField: textField,
                    range: NSRange(location: inputLocation, length: 0),
                    newString: randomCharacter) {
                    
                    if shouldChangeCharacter {
                        textField.text?.append(randomCharacter)
                    }
                    
                } else {
                    print("Failed to get the status of textField's delegation")
                    break
                }
            }
            
            let textFieldValue = Double(textField.text!)
            XCTAssertNotNil(textFieldValue)
            XCTAssertLessThan(textFieldValue!, 1000)
        }
    }
    
    func testFirstZeroCharacterIsRemoved() {
        textField.text = "0"
        
    }
    
    private func shouldTextFieldChangeCharacters(textField: UITextField, range: NSRange, newString: String) -> Bool? {
        
        guard let shouldChangeCharacters = textField.delegate?.textField?(
                textField,
                shouldChangeCharactersIn: range,
                replacementString: newString)
        else {
            print("Failed to get valid value of textField's delegate")
            return nil
        }
        
        return shouldChangeCharacters
    }

}

