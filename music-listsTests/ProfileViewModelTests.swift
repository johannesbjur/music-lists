//
//  music_listsTests.swift
//  music-listsTests
//
//  Created by Johannes Bjurströmer on 2021-05-17.
//

import XCTest
@testable import music_lists

class ProfileViewModelTests: XCTestCase {
    
    var viewModel: ProfileView.ProfileViewModel!
    var mockAPICaller: MockAPICaller!

    override func setUp() {
        mockAPICaller = MockAPICaller()
        viewModel = ProfileView.ProfileViewModel(apiCallerService: mockAPICaller)
    }
    
    func testReturnUserDataFromAPICaller() {
        let expectation = XCTestExpectation(description: "Wait for main thread")
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.user?.display_name, "testName")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testReturnTopTracksFromAPICaller() {
        let expectation = XCTestExpectation(description: "Wait for main thread")
        
        DispatchQueue.main.async {
            XCTAssertNotNil(self.viewModel.topTracks)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

}
