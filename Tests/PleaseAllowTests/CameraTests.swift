//
//  CameraTests.swift
//  PleaseAllowTests
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import XCTest
@testable import PleaseAllow

let emptyHandler: Please.Reply = { _ in }

class CameraTests: XCTestCase {
    
    func testThatWeCanRequestIfCameraIsNotDetermined() {
        let camera = CameraManager(.notDetermined, true)
        camera.resultHandler = emptyHandler
        XCTAssertTrue(camera.canRequest)
    }
    
    func testThatWeCannotRequestIfCameraIsRestricted() {
        let camera = CameraManager(.restricted, true)
        camera.resultHandler = emptyHandler
        XCTAssertFalse(camera.canRequest)
    }
    
    func testThatWeCannotRequestIfCameraPermissionWasDenied() {
        let camera = CameraManager(.denied, true)
        camera.resultHandler = emptyHandler
        XCTAssertFalse(camera.canRequest)
    }
    
    func testThatWeCannotRequestIfCameraPermissionIsAlreadyAuthorized() {
        let camera = CameraManager(.authorized, true)
        camera.resultHandler = emptyHandler
        XCTAssertFalse(camera.canRequest)
    }
    
    func testThatCameraReturnsAuthorizedCorrectly() {
        var camera = CameraManager(.authorized, true)
        let exp = expectation(description: "Expectation")
        camera.request { result in
            XCTAssertEqual(result, Please.Result.allowed)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatCameraReturnsRestrictedCorrectly() {
        var camera = CameraManager(.restricted, true)
        let exp = expectation(description: "Expectation")
        camera.request { result in
            XCTAssertEqual(result, Please.Result.restricted)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatCameraReturnsDeniedCorrectly() {
        var camera = CameraManager(.denied, true)
        let exp = expectation(description: "Expectation")
        camera.request { result in
            XCTAssertEqual(result, Please.Result.hardDenial)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}
