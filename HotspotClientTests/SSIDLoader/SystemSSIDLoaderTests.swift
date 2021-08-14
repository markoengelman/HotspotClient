//
//  SystemSSIDLoaderTests.swift
//  HotspotClientTests
//
//  Created by Marko Engelman on 14/08/2021.
//

import XCTest
@testable import HotspotClient

class SystemSSIDLoaderTests: XCTestCase {
  func test_load_uses_iOS14API_ifAvailable() {
    let sut = makeSUT()
    let exp = expectation(description: "Expecting to call iOS 14 api")
    sut.load { _ in exp.fulfill() }
    wait(for: [exp], timeout: 1.0)
    XCTAssertTrue(sut.iOS14APIUsed)
  }
}

// MARK: - Private
private extension SystemSSIDLoaderTests {
  class SystemSSIDLoaderAnalyzer: SystemSSIDLoader {
    var iOS14APIUsed: Bool = false
    
    @available(iOS 14.0, *)
    override func fetchCurrentNetwork(completion: @escaping ([String]) -> Void) {
      iOS14APIUsed = true
      super.fetchCurrentNetwork(completion: completion)
    }
  }
  
  func makeSUT() -> SystemSSIDLoaderAnalyzer {
    let sut = SystemSSIDLoaderAnalyzer()
    return sut
  }
}
