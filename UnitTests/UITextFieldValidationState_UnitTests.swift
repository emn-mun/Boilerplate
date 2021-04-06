import XCTest
import UIKit
@testable import Boilerplate

class UITextFieldValidationState_UnitTests: XCTestCase {

    func testPendingInput() {
        let textField = UITextField(frame: .zero)
        textField.set(validationStatus: .pendingInput)
        XCTAssertTrue(textField.layer.borderColor == UIColor.black.cgColor)
    }

    func testInvalidInput() {
        let textField = UITextField(frame: .zero)
        textField.set(validationStatus: .invalid)
        XCTAssertTrue(textField.layer.borderColor == UIColor.red.cgColor)
    }

    func testValidInput() {
        let textField = UITextField(frame: .zero)
        textField.set(validationStatus: .valid)
        XCTAssertTrue(textField.layer.borderColor == UIColor.blue.cgColor)
    }
}
