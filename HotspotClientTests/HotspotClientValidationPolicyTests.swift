//
//  HotspotClientValidationPolicyTests.swift
//  HotspotClientTests
//
//  Created by Marko Engelman on 14/08/2021.
//

import XCTest
@testable import HotspotClient

class HotspotClientValidationPolicyTests: XCTestCase {
  func test_validates_retryCount() {
    let maxCount = HotspotClientValidationPolicy.maxRetryCount
    XCTAssertTrue(HotspotClientValidationPolicy.validateRetryCount(against: maxCount))
    XCTAssertTrue(HotspotClientValidationPolicy.validateRetryCount(against: maxCount - 1))
    XCTAssertFalse(HotspotClientValidationPolicy.validateRetryCount(against: maxCount + 1))
  }
}
