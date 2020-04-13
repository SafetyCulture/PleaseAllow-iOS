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
        let location = LocationManager(.notDetermined, true)
        location.resultHandler = emptyHandler
        XCTAssertTrue(location.canRequest)
    }
    
    func testThatWeCannotRequestIfLocationIsRestricted() {
        let location = LocationManager(.restricted, true)
        location.resultHandler = emptyHandler
        XCTAssertFalse(location.canRequest)
    }
    
    func testThatWeCannotRequestIfLocationPermissionWasDenied() {
        let location = LocationManager(.denied, true)
        location.resultHandler = emptyHandler
        XCTAssertFalse(location.canRequest)
    }
    
    func testThatWeCannotRequestIfLocationPermissionIsAuthorizedWhenInUse() {
        let location = LocationManager(.authorizedWhenInUse, true)
        location.resultHandler = emptyHandler
        XCTAssertFalse(location.canRequest)
    }
    
    func testThatWeCannotRequestIfLocationPermissionIsAuthorizedAlways() {
        let location = LocationManager(.authorizedAlways, true)
        location.resultHandler = emptyHandler
        XCTAssertFalse(location.canRequest)
    }
    
    func testThatLocationReturnsAuthorizedCorrectlyForWhenInUse() {
        var location = LocationManager(.authorizedWhenInUse, true)
        location.locationType = .whenInUse
        let exp = expectation(description: "Expectation")
        location.request { result in
            XCTAssertEqual(result, Please.Result.allowed)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatLocationReturnsAuthorizedCorrectlyForAlways() {
        var location = LocationManager(.authorizedAlways, true)
        location.locationType = .whenInUse
        let exp = expectation(description: "Expectation")
        location.request { result in
            XCTAssertEqual(result, Please.Result.allowed)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatLocationReturnsRestrictedCorrectly() {
        var location = LocationManager(.restricted, true)
        let exp = expectation(description: "Expectation")
        location.request { result in
            XCTAssertEqual(result, Please.Result.restricted)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatLocationReturnsDeniedCorrectly() {
        var location = LocationManager(.denied, true)
        let exp = expectation(description: "Expectation")
        location.request { result in
            XCTAssertEqual(result, Please.Result.hardDenial)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}

