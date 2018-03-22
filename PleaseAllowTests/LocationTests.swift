//
//  LocationTests.swift
//  PleaseAllowTests
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import XCTest
@testable import PleaseAllow

class locationTests: XCTestCase {
    
    func testThatWeCanRequestIfLocationIsNotDetermined() {
        let location = Location(.notDetermined, true)
        location.resultHandler = emptyHandler
        XCTAssertTrue(location.canRequest)
    }
    
    func testThatWeCannotRequestIfLocationIsRestricted() {
        let location = Location(.restricted, true)
        location.resultHandler = emptyHandler
        XCTAssertFalse(location.canRequest)
    }
    
    func testThatWeCannotRequestIfLocationPermissionWasDenied() {
        let location = Location(.denied, true)
        location.resultHandler = emptyHandler
        XCTAssertFalse(location.canRequest)
    }
    
    func testThatWeCannotRequestIfLocationPermissionIsAuthorizedWhenInUse() {
        let location = Location(.authorizedWhenInUse, true)
        location.resultHandler = emptyHandler
        XCTAssertFalse(location.canRequest)
    }
    
    func testThatWeCannotRequestIfLocationPermissionIsAuthorizedAlways() {
        let location = Location(.authorizedAlways, true)
        location.resultHandler = emptyHandler
        XCTAssertFalse(location.canRequest)
    }
    
    func testThatLocationReturnsAuthorizedCorrectlyForWhenInUse() {
        var location = Location(.authorizedWhenInUse, true)
        location.locationType = .whenInUse
        let exp = expectation(description: "Expectation")
        location.request { (result, error) in
            XCTAssertEqual(result, PleaseAllowResult.allowed)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatLocationReturnsAuthorizedCorrectlyForAlways() {
        var location = Location(.authorizedAlways, true)
        location.locationType = .whenInUse
        let exp = expectation(description: "Expectation")
        location.request { (result, error) in
            XCTAssertEqual(result, PleaseAllowResult.allowed)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatLocationReturnsRestrictedCorrectly() {
        var location = Location(.restricted, true)
        let exp = expectation(description: "Expectation")
        location.request { (result, error) in
            XCTAssertEqual(result, PleaseAllowResult.restricted)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatLocationReturnsDeniedCorrectly() {
        var location = Location(.denied, true)
        let exp = expectation(description: "Expectation")
        location.request { (result, error) in
            XCTAssertEqual(result, PleaseAllowResult.hardDenial)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}

