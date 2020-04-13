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
        let photoLibrary = PhotoLibraryManager(.notDetermined, true)
        photoLibrary.resultHandler = emptyHandler
        XCTAssertTrue(photoLibrary.canRequest)
    }
    
    func testThatWeCannotRequestIfPhotoLibraryIsRestricted() {
        let photoLibrary = PhotoLibraryManager(.restricted, true)
        photoLibrary.resultHandler = emptyHandler
        XCTAssertFalse(photoLibrary.canRequest)
    }
    
    func testThatWeCannotRequestIfPhotoLibraryPermissionWasDenied() {
        let photoLibrary = PhotoLibraryManager(.denied, true)
        photoLibrary.resultHandler = emptyHandler
        XCTAssertFalse(photoLibrary.canRequest)
    }
    
    func testThatWeCannotRequestIfPhotoLibraryPermissionIsAlreadyAuthorized() {
        let photoLibrary = PhotoLibraryManager(.authorized, true)
        photoLibrary.resultHandler = emptyHandler
        XCTAssertFalse(photoLibrary.canRequest)
    }
    
    func testThatPhotoLibraryReturnsAuthorizedCorrectly() {
        var photoLibrary = PhotoLibraryManager(.authorized, true)
        let exp = expectation(description: "Expectation")
        photoLibrary.request { result in
            XCTAssertEqual(result, Please.Result.allowed)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatPhotoLibraryReturnsRestrictedCorrectly() {
        var photoLibrary = PhotoLibraryManager(.restricted, true)
        let exp = expectation(description: "Expectation")
        photoLibrary.request { result in
            XCTAssertEqual(result, Please.Result.restricted)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatPhotoLibraryReturnsDeniedCorrectly() {
        var photoLibrary = PhotoLibraryManager(.denied, true)
        let exp = expectation(description: "Expectation")
        photoLibrary.request { result in
            XCTAssertEqual(result, Please.Result.hardDenial)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}

