//
//  CameraTests.swift
//  PleaseAllowTests
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import XCTest
@testable import PleaseAllow

let emptyHandler: Please.Reply = { _, _ in }

class CameraTests: XCTestCase {
    
    func testThatWeCanRequestIfCameraIsNotDetermined() {
        let camera = Camera(.notDetermined, true)
        camera.resultHandler = emptyHandler
        XCTAssertTrue(camera.canRequest)
    }
    
    func testThatWeCannotRequestIfCameraIsRestricted() {
        let camera = Camera(.restricted, true)
        camera.resultHandler = emptyHandler
        XCTAssertFalse(camera.canRequest)
    }
    
    func testThatWeCannotRequestIfCameraPermissionWasDenied() {
        let camera = Camera(.denied, true)
        camera.resultHandler = emptyHandler
        XCTAssertFalse(camera.canRequest)
    }
    
    func testThatWeCannotRequestIfCameraPermissionIsAlreadyAuthorized() {
        let camera = Camera(.authorized, true)
        camera.resultHandler = emptyHandler
        XCTAssertFalse(camera.canRequest)
    }
    
    func testThatCameraReturnsAuthorizedCorrectly() {
        var camera = Camera(.authorized, true)
        let exp = expectation(description: "Expectation")
        camera.request { (result, error) in
            XCTAssertEqual(result, Please.Result.allowed)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatCameraReturnsRestrictedCorrectly() {
        var camera = Camera(.restricted, true)
        let exp = expectation(description: "Expectation")
        camera.request { (result, error) in
            XCTAssertEqual(result, Please.Result.restricted)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatCameraReturnsDeniedCorrectly() {
        var camera = Camera(.denied, true)
        let exp = expectation(description: "Expectation")
        camera.request { (result, error) in
            XCTAssertEqual(result, Please.Result.hardDenial)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}
