//
//  SystemSSIDLoaderTests.swift
//  HotspotClientTests
//
//  Created by Marko Engelman on 14/08/2021.
//

import XCTest
@testable import HotspotClient

class SystemSSIDLoaderTests: XCTestCase {
  func test_load_uses_iOS14API_ifAvailable() throws {
    guard #available(iOS 14.0, *) else {
      throw XCTSkip("This test is designed for latest iOS api only.")
    }
    let sut = makeSUT()
    let exp = expectation(description: "Expecting to call iOS 14 api")
    sut.load { _ in exp.fulfill() }
    wait(for: [exp], timeout: 1.0)
    XCTAssertTrue(sut.iOS14APIUsed)
    XCTAssertFalse(sut.legacyAPIUsed)
  }
  
  func test_load_uses_legacyAPI_onOlderiOSVersions() throws {
    let version = Double(UIDevice.current.systemVersion)!
    let isTestAvailable = version < 14.0
    try XCTSkipIf(!isTestAvailable , "This test is not designed for iOS newer or equalt to 14.0")
    let sut = makeSUT()
    let exp = expectation(description: "Expecting to call legacy api")
    sut.load { _ in exp.fulfill() }
    wait(for: [exp], timeout: 1.0)
    XCTAssertTrue(sut.legacyAPIUsed)
    XCTAssertFalse(sut.iOS14APIUsed)
  }
}

// MARK: - Private
private extension SystemSSIDLoaderTests {
  class SystemSSIDLoaderMock: SystemSSIDLoader {
    var iOS14APIUsed: Bool = false
    var legacyAPIUsed: Bool = false
    
    @available(iOS 14.0, *)
    override func fetchCurrentNetwork(completion: @escaping ([String]) -> Void) {
      iOS14APIUsed = true
      super.fetchCurrentNetwork(completion: completion)
    }
    
    override func compyInterfaces() -> [String] {
      legacyAPIUsed = true
      return super.compyInterfaces()
    }
  }
  
  func makeSUT() -> SystemSSIDLoaderMock {
    let sut = SystemSSIDLoaderMock()
    return sut
  }
}
