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
    
    func testTextFieldsInput() {
        let app = XCUIApplication()
        let heightField = app.textFields.element(boundBy: 0)
        let weightField = app.textFields.element(boundBy: 1)
        
        heightField.tap()
        heightField.typeText("177.7")
        XCTAssertTrue(heightField.value as! String == "177.7")
        
        app.buttons["Next"].tap()
        weightField.typeText("77.7")
        XCTAssertTrue(weightField.value as! String == "77.7")
        app.buttons["Done"].tap()
    }
    
    func testPressViewToDismissKeyboard() {
        let app = XCUIApplication()
        let heightField = app.textFields.element(boundBy: 0)
        let weightField = app.textFields.element(boundBy: 1)
        
        heightField.tap()
        app.staticTexts.firstMatch.tap()
        XCTAssertFalse(heightField.hasFocus)
        
        weightField.tap()
        app.staticTexts.firstMatch.tap()
        XCTAssertFalse(weightField.hasFocus)
    }
    
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
        
        XCTAssertEqual(app.alerts.element.label, "Done!")
        // Dismiss alert message.
        app.buttons["OK"].tap()
        
        // Test if the current view is Home.
        XCTAssert(app.buttons["Calculate"].exists)
    }
    
    func testRecalculateButton() {
        let app = XCUIApplication()
        let heightField = app.textFields.element(boundBy: 0)
        let weightField = app.textFields.element(boundBy: 1)
        
        testTextFieldsInput()
        app.buttons["Calculate"].tap()
        app.buttons["Recalculate"].tap()
        
        XCTAssert(heightField.value as! String == "Height")
        XCTAssert(weightField.value as! String == "Weight")
    }
    
    func testHintLabelAppearance() {
        let app = XCUIApplication()
        let heightField = app.textFields.element(boundBy: 0)
        let weightField = app.textFields.element(boundBy: 1)
        
        heightField.tap()
        // Dismiss the keyboard.
        app.staticTexts.firstMatch.tap()
        
        let hintLabel = app.staticTexts["hintLabel"]
        let hintText = hintLabel.label
        XCTAssertFalse(hintText.isEmpty)
        
        weightField.tap()
        // Dismiss the keyboard.
        app.staticTexts.firstMatch.tap()
        
        XCTAssertFalse(hintText.isEmpty)
        
        heightField.tap()
        heightField.typeText("0")
        app.buttons["Next"].tap()
        weightField.typeText("0")
        app.buttons["Done"].tap()
        
        XCTAssertFalse(hintText.isEmpty)
    }
    
}
