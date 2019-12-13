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
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    
    
    func testSuccessResponce() {
        let session = NetworkSessionMock()
        let networkManager = NetworkService(session: session)
        let data = "data"
        session.data = data
        let url = URL(string: "url")!
        
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
    



