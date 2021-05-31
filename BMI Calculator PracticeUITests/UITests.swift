//
//  UITests.swift
//  BMI Calculator PracticeUITests
//
//  Created by Jason Ou Yang on 2020/6/19.
//  Copyright © 2020 Jason Ou Yang. All rights reserved.
//

import XCTest

class UITests: XCTestCase {

    override class func setUp() {
        super.setUp()
        let app = XCUIApplication()
        app.launch()
    }
    
    /// Test the appearance of the hint text label when certain conditions apply.
    func testHintLabelAppearance() {
        let app = XCUIApplication()
        let heightField = app.textFields.element(boundBy: 0)
        let weightField = app.textFields.element(boundBy: 1)
        
        // Test hint appearance when only a zero character is inputted into the weight text field.
        heightField.tap()
        app.staticTexts.firstMatch.tap()
        XCTAssert(app.staticTexts["hintLabel"].exists, "Hint label should have a text message.")
        
        // Test hint appearance when only a zero character is inputted into the weight text field.
        weightField.tap()
        app.staticTexts.firstMatch.tap()
        XCTAssert(app.staticTexts["hintLabel"].exists, "Hint label should have a text message.")
        
        // Test hint appearance when a zero character is inputted into the text field.
        heightField.tap()
        heightField.typeText("0")
        app.buttons["Next"].tap()
        weightField.typeText("0")
        app.buttons["Done"].tap()
        XCTAssert(app.staticTexts["hintLabel"].exists, "Hint label should have a text message.")
        
        // Test hint disappearance when both text fields have values other than zero.
        heightField.tap()
        heightField.typeText("177")
        app.buttons["Next"].tap()
        weightField.typeText("77")
        app.buttons["Done"].tap()
        XCTAssertFalse(app.staticTexts["hintLabel"].exists, "Hint label should not have a text message.")
    }
    
    /// Test the dismissal of the keyboard when user presses the view other than the keyboard.
    func testPressViewToDismissKeyboard() {
        let app = XCUIApplication()
        let heightField = app.textFields.element(boundBy: 0)
        let weightField = app.textFields.element(boundBy: 1)
        
        heightField.tap()
        app.staticTexts.firstMatch.tap()
        XCTAssertFalse(heightField.hasFocus, "Height text field should have not being focused.")
        
        weightField.tap()
        app.staticTexts.firstMatch.tap()
        XCTAssertFalse(weightField.hasFocus, "Weight text field should have not being focused.")
    }
    
    /// Test the validation of user's input in the height and weight text field.
    func testTextFieldsInput() {
        let app = XCUIApplication()
        let heightField = app.textFields.element(boundBy: 0)
        let weightField = app.textFields.element(boundBy: 1)
        let height = Double.random(in: 100.0...200.0)
        let weight = Double.random(in: 20.0...200.0)
        let validHeightInput = (height * 10).rounded(.down) / 10
        let validWeightInput = (weight * 10).rounded(.down) / 10
        let nextButtonTitle = "Next"
        let doneButtonTitle = "Done"
        
        heightField.tap()
        heightField.typeText(String(height))
        
        XCTAssert(heightField.value as! String == String(validHeightInput), "Value in the height text field is is not valid.")
        
        app.buttons[nextButtonTitle].tap()
        weightField.typeText(String(weight))
        XCTAssert(weightField.value as! String == String(validWeightInput), "Value in the weight text field is is not valid.")
        
        app.buttons[doneButtonTitle].tap()
        XCTAssertFalse(app.keyboards.element.exists, "The keyboard should have had been dismissed.")
    }
    
    /// Test the HealthKit authorization process.
    func testHealthKitAuthorizationAndSync() {
        let app = XCUIApplication()
        testTextFieldsInput()
        
        app.buttons["Calculate"].tap()
        app.buttons["Save to Health App"].tap()
        
        // HealthKit permission is required
        if app.buttons["Skip for Now"].exists {
            app.buttons["OK"].tap()
            
            let turnOnAllCategories = app.tables.cells.firstMatch
            let allowCategoriesConnectionButton = app.navigationBars.buttons.element(boundBy: 1)
            
            if turnOnAllCategories.waitForExistence(timeout: 3) {
                turnOnAllCategories.tap()
                allowCategoriesConnectionButton.tap()
            }
        }
        
        XCTAssertEqual(app.alerts.element.label, "Done!", "The alert title should be 'Done!'.")
        // Dismiss alert message.
        app.buttons["OK"].tap()
        
        // Test if the current view is Home.
        XCTAssert(app.buttons["Calculate"].exists, "Current view should be 'Home' view.")
    }
    
    /// Test the Recalculate button and the auto clearing of the text fields.
    func testRecalculateButton() {
        let app = XCUIApplication()
        let heightField = app.textFields.element(boundBy: 0)
        let weightField = app.textFields.element(boundBy: 1)
        
        testTextFieldsInput()
        app.buttons["Calculate"].tap()
        app.buttons["Recalculate"].tap()
        
        XCTAssert(heightField.value as! String == "Height", "Value of the height text field should be the placeholder text.")
        XCTAssert(weightField.value as! String == "Weight", "Value of the weight text field should be the placeholder text.")
    }
    
}
