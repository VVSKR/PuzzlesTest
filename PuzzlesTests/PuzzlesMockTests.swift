//
//  PuzzlesMockTests.swift
//  PuzzlesTests
//
//  Created by Vova SKR on 11/12/2019.
//  Copyright © 2019 Leonid Serebryanyy. All rights reserved.
//

import XCTest
@testable import Puzzles


class NetworkSessionMock: NetworkServiceProtocol {
    
    var data: String?
    func loadQuiz(request: URLRequest, completion: @escaping (Result<String, Error>) -> ()) {
        completion(.success(data ?? "data"))
    }
}


class PuzzlesMockTests: XCTestCase {
    
    var session: NetworkSessionMock!
    var networkManager: NetworkService!
    
    override func setUp() {
        session = NetworkSessionMock()
        networkManager = NetworkService(session: session)
        
    }
    
    override func tearDown() {
        networkManager = nil
        session = nil
        
    }
    
    
    
    
    func testSuccessResponce() {
        
        
        let data = "data"
        let url = URL(string: "url")!
        session.data = data
        
        var resultData: String?
        networkManager.loadQuiz(url: url) { (result) in
            switch result {
            case .success(let data):
                resultData = data
            case .failure(let _): break
                
            }
        }
        XCTAssertEqual(data, resultData)
        
    }
    
    
    
}




