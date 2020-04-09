//
//  PhotoLibraryTests.swift
//  PleaseAllowTests
//
//  Created by Gagandeep Singh on 22/3/18.
//  Copyright © 2018 Gagandeep Singh. All rights reserved.
//

import XCTest
@testable import PleaseAllow

class photoLibraryTests: XCTestCase {
    
    func testThatWeCanRequestIfPhotoLibraryIsNotDetermined() {
        let photoLibrary = PhotoLibrary(.notDetermined, true)
        photoLibrary.resultHandler = emptyHandler
        XCTAssertTrue(photoLibrary.canRequest)
    }
    
    func testThatWeCannotRequestIfPhotoLibraryIsRestricted() {
        let photoLibrary = PhotoLibrary(.restricted, true)
        photoLibrary.resultHandler = emptyHandler
        XCTAssertFalse(photoLibrary.canRequest)
    }
    
    func testThatWeCannotRequestIfPhotoLibraryPermissionWasDenied() {
        let photoLibrary = PhotoLibrary(.denied, true)
        photoLibrary.resultHandler = emptyHandler
        XCTAssertFalse(photoLibrary.canRequest)
    }
    
    func testThatWeCannotRequestIfPhotoLibraryPermissionIsAlreadyAuthorized() {
        let photoLibrary = PhotoLibrary(.authorized, true)
        photoLibrary.resultHandler = emptyHandler
        XCTAssertFalse(photoLibrary.canRequest)
    }
    
    func testThatPhotoLibraryReturnsAuthorizedCorrectly() {
        var photoLibrary = PhotoLibrary(.authorized, true)
        let exp = expectation(description: "Expectation")
        photoLibrary.request { (result, error) in
            XCTAssertEqual(result, PleaseAllowResult.allowed)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatPhotoLibraryReturnsRestrictedCorrectly() {
        var photoLibrary = PhotoLibrary(.restricted, true)
        let exp = expectation(description: "Expectation")
        photoLibrary.request { (result, error) in
            XCTAssertEqual(result, PleaseAllowResult.restricted)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatPhotoLibraryReturnsDeniedCorrectly() {
        var photoLibrary = PhotoLibrary(.denied, true)
        let exp = expectation(description: "Expectation")
        photoLibrary.request { (result, error) in
            XCTAssertEqual(result, PleaseAllowResult.hardDenial)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}

