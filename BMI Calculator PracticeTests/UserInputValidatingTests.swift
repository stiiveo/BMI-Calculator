//
//  UserInputValidatingTests.swift
//  BMI Calculator PracticeTests
//
//  Created by Jason Ou Yang on 2020/6/19.
//  Copyright © 2020 Jason Ou Yang. All rights reserved.
//

@testable import BMI_Calculator_Practice
import XCTest

/// Test the text field input provided by the user.
class UserInputValidatingTests: XCTestCase {
    
    var homeVC: HomeViewController!
    var textField: CustomTextField!

    override func setUp() {
        super.setUp()
        textField = CustomTextField()
        homeVC = HomeViewController()
        homeVC.loadView()
        textField.delegate = homeVC
    }

    override func tearDown() {
        textField = nil
        homeVC = nil
        super.tearDown()
    }
    
    /// Test that the value of the text field is cleared each time it becomes the first responder.
    func testTextFieldAutoClearing() {
        textField.text = "Text to be cleared"
        textField.becomeFirstResponder()
        
        if textField.isFirstResponder {
            XCTAssertTrue(textField.text!.isEmpty, "The text field's value should be emptied when it becomes the first responder.")
        }
    }
    
    /// Test the auto addition of a zero character if the first input is a dot character.
    func testAutoAdditionOfZeroBeforeDot() {
        for _ in 1..<100 {
            textField.text = ""
            let shouldChangeCharacter = shouldTextFieldChangeCharacters(textField: textField, range: NSRange(location: 0, length: 0), newString: ".")!
            if shouldChangeCharacter {
                textField.text!.append(".")
            }
            XCTAssert(textField.text == "0" + ".", "A zero character should be added to the text field as the first character if the first input is a dot character.")
        }
    }
    
    
    /// Test that the input value is never more than 1000.
    func testMaxInputValueLimiter() {
        for _ in 0..<100 {
            textField.text = ""
            
            // Attempt to input seven random integers in a row
            for _ in 0..<7 {
                let randomCharacter = String(Int.random(in: 0...9))
                let inputLocation = textField.text!.count
                
                let shouldChangeCharacter = shouldTextFieldChangeCharacters(
                    textField: textField,
                    range: NSRange(location: inputLocation, length: 0),
                    newString: randomCharacter)!
                
                if shouldChangeCharacter {
                    textField.text!.append(randomCharacter)
                }
            }
            
            let textFieldValue = Double(textField.text!)
            XCTAssertNotNil(textFieldValue, "The value of the text field should be able to be converted into a Double value.")
            XCTAssertLessThan(textFieldValue!, 1000, "The converted Double value should be less than 1000.")
        }
    }
    
    /// Test that only one dot character should be allowed to be inputted.
    func testAllowOnlyOneDigitCharacter() {
        textField.text = "1."
        let shouldAllowAnotherDot = shouldTextFieldChangeCharacters(textField: textField, range: NSRange(location: textField.text!.count, length: 0), newString: ".")!
        XCTAssertFalse(shouldAllowAnotherDot, "A dot character should not be accepted if one is already present.")
    }
    
    /// Test that only one digit place can be accepted.
    func testAllowOnlyOneDigitPlace() {
        textField.text = "1.1"
        let shouldChangeCharacter = shouldTextFieldChangeCharacters(textField: textField, range: NSRange(location: textField.text!.count, length: 0), newString: "1")!
        XCTAssertFalse(shouldChangeCharacter, "Digit place more than one should not be accepted.")
    }

}

extension UserInputValidatingTests {
    
    /// A proxy method to check whether the provided new string should be accepted to change the text field's characters.
    /// - Parameters:
    ///   - textField: The text field to be checked onto.
    ///   - range: The range in which the characters should be changed.
    ///   - newString: The string to be added to the text field.
    /// - Returns: The boolean value on whether the text field should change the characters.
    private func shouldTextFieldChangeCharacters(textField: UITextField, range: NSRange, newString: String) -> Bool? {
        guard let shouldChangeCharacters = textField.delegate?.textField?(
                textField,
                shouldChangeCharactersIn: range,
                replacementString: newString)
        else {
            print("Failed to get the textField's delegate method 'shouldChangeCharacters'.")
            return nil
        }
        return shouldChangeCharacters
    }
    
}
