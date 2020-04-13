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
        let contacts = ContactsManager(.notDetermined, true)
        contacts.resultHandler = emptyHandler
        XCTAssertTrue(contacts.canRequest)
    }
    
    func testThatWeCannotRequestIfContactsIsRestricted() {
        let contacts = ContactsManager(.restricted, true)
        contacts.resultHandler = emptyHandler
        XCTAssertFalse(contacts.canRequest)
    }
    
    func testThatWeCannotRequestIfContactsPermissionWasDenied() {
        let contacts = ContactsManager(.denied, true)
        contacts.resultHandler = emptyHandler
        XCTAssertFalse(contacts.canRequest)
    }
    
    func testThatWeCannotRequestIfContactsPermissionIsAlreadyAuthorized() {
        let contacts = ContactsManager(.authorized, true)
        contacts.resultHandler = emptyHandler
        XCTAssertFalse(contacts.canRequest)
    }
    
    func testThatContactsReturnsAuthorizedCorrectly() {
        var contacts = ContactsManager(.authorized, true)
        let exp = expectation(description: "Expectation")
        contacts.request { result in
            XCTAssertEqual(result, Please.Result.allowed)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatContactsReturnsRestrictedCorrectly() {
        var contacts = ContactsManager(.restricted, true)
        let exp = expectation(description: "Expectation")
        contacts.request { result in
            XCTAssertEqual(result, Please.Result.restricted)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatContactsReturnsDeniedCorrectly() {
        var contacts = ContactsManager(.denied, true)
        let exp = expectation(description: "Expectation")
        contacts.request { result in
            XCTAssertEqual(result, Please.Result.hardDenial)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}

