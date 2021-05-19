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
    
    var textField: CustomTextField!
    var homeVC: HomeViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        textField = CustomTextField()
        homeVC = HomeViewController()
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
    
    func testAutoZeroCharAddition() {
        homeVC.loadView()
        textField.delegate = homeVC
        
        textField.text = ""
        guard let shouldChangeCharacters = textField.delegate?.textField?(textField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: ".") else {
            print("Failed to get text field delegate assertion")
            return
        }
        
        XCTAssert(shouldChangeCharacters)
        textField.text! += "."
        
        XCTAssert(textField.text == "0.")
    }
    
    //    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
