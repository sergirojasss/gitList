//
//  GitHubListTests.swift
//  GitHubListTests
//
//  Created by Sergi Rojas on 03/03/2020.
//  Copyright © 2020 Sergi Rojas. All rights reserved.
//

import XCTest
@testable import GitHubList

class GitHubListTests: XCTestCase {

    var sut: URLSession!
    var vc: GitHubProjectController = GitHubProjectController()

    override func setUp() {
      super.setUp()
    }

    override func tearDown() {
      super.tearDown()
    }

//    {
//        var url = Constants.APIBase
//        if gits.count % Constants.APIpagination == 0  {
//            let page = (gits.count/Constants.APIpagination)+1
//            url.append("?page=\(page)")
//        }
//        lastRequestCount = -2 //to avoid load again if user scrolls super fast
//        print(url)
//        return url
//    }
    
    func testConstructURL() {
        // given
        
        // when
        
        
        // then
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
