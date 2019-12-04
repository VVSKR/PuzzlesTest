//
//  PuzzlesTests.swift
//  PuzzlesTests
//
//  Created by Vova SKR on 04/12/2019.
//  Copyright © 2019 Leonid Serebryanyy. All rights reserved.
//

import XCTest
@testable import Puzzles

class PuzzlesTests: XCTestCase {
    
    var sessionUnderTest: URLSession!
    
    override func setUp() {
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        
    }
    
    func testValidCallToUrlHTTPStatusCode200() {
        
        let url = NetworkService().keyURL
        
        let promise = expectation(description: "Status code: 200")
        let dataTask = sessionUnderTest.dataTask(with: url) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
           
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testImageCountInArrayAfterRequest() {
        
        //Arrsnge
        let networkService = NetworkService()
        
        //Act
        XCTAssertEqual(networkService.results.count, 0, "imageResults should be empty before the data task runs")
        networkService.loadPuzzle { (_) in }
        
        //Assert
        XCTAssertEqual(networkService.results.count, 4, "imageResults should be 4 after the data task runs")
    }
    
    
    
    func testPerformanceExample() {
        
        measure {
            
        }
    }
    
}
