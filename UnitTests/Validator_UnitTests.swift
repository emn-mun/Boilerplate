import XCTest
@testable import Boilerplate

class Validator_UnitTests: XCTestCase {
    let validator = Validator()

    func test_giveEmptyEmail_validationIsPendingInput() {
        XCTAssertEqual(validator.validateEmail(for: ""), ValidationState.pendingInput)
    }

    func test_giveNilEmail_validationIsPendingInput() {
        XCTAssertEqual(validator.validateEmail(for: nil), ValidationState.pendingInput)
    }

    func test_givenInvalidEmail_validationFails() {
        XCTAssertEqual(validator.validateEmail(for: "mail"), ValidationState.invalid)
    }

    func test_givenValidEmail_validationIsSuccessful() {
        XCTAssertEqual(validator.validateEmail(for: "mail@"), ValidationState.valid)
    }

    func test_givenEmptyPassword_validationFails() {
        XCTAssertEqual(validator.validatePassword(for: ""), ValidationState.invalid)
    }

    func test_givenNilPassword_validationIsPendingInput() {
        XCTAssertEqual(validator.validatePassword(for: nil), ValidationState.pendingInput)
    }

    func test_givenValidPassword_validationIsSuccessful() {
        XCTAssertEqual(validator.validatePassword(for: "pass"), ValidationState.valid)
    }

}
