//
//  ContactsTests.swift
//  PleaseAllowTests
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import XCTest
@testable import PleaseAllow

class ContactsTests: XCTestCase {
    
    func testThatWeCanRequestIfContactsIsNotDetermined() {
        let contacts = Contacts(.notDetermined, true)
        contacts.resultHandler = emptyHandler
        XCTAssertTrue(contacts.canRequest)
    }
    
    func testThatWeCannotRequestIfContactsIsRestricted() {
        let contacts = Contacts(.restricted, true)
        contacts.resultHandler = emptyHandler
        XCTAssertFalse(contacts.canRequest)
    }
    
    func testThatWeCannotRequestIfContactsPermissionWasDenied() {
        let contacts = Contacts(.denied, true)
        contacts.resultHandler = emptyHandler
        XCTAssertFalse(contacts.canRequest)
    }
    
    func testThatWeCannotRequestIfContactsPermissionIsAlreadyAuthorized() {
        let contacts = Contacts(.authorized, true)
        contacts.resultHandler = emptyHandler
        XCTAssertFalse(contacts.canRequest)
    }
    
    func testThatContactsReturnsAuthorizedCorrectly() {
        var contacts = Contacts(.authorized, true)
        let exp = expectation(description: "Expectation")
        contacts.request { (result, error) in
            XCTAssertEqual(result, Please.Result.allowed)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatContactsReturnsRestrictedCorrectly() {
        var contacts = Contacts(.restricted, true)
        let exp = expectation(description: "Expectation")
        contacts.request { (result, error) in
            XCTAssertEqual(result, Please.Result.restricted)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatContactsReturnsDeniedCorrectly() {
        var contacts = Contacts(.denied, true)
        let exp = expectation(description: "Expectation")
        contacts.request { (result, error) in
            XCTAssertEqual(result, Please.Result.hardDenial)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}

