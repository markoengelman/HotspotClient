//
//  HotspotClientTests.swift
//  HotspotClientTests
//
//  Created by Marko Engelman on 13/08/2021.
//

import XCTest
import NetworkExtension
@testable import HotspotClient

class HotspotClientTests: XCTestCase {
  func test_init_hasNoSideEffectsOnHotspotManger() {
    let manager = NEHotspotConfigurationManager()
    let sut = makeSUT(manager: manager)
    XCTAssertEqual(manager, sut.hotspotManager)
  }
  
  func test_connect_eventuallyDeliversResult() {
    let sut = makeSUT()
    let exp = expectation(description: "Waiting for result")
    sut.connect(with: anyConfiguration) { result in
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
  }
  
  func test_disconnect_removesConfiguration() {
    let sut = makeSUT()
    let configuration = anyConfiguration
    let exp = expectation(description: "Waiting for result")
    
    var SSIDs: [String] = []
    sut.connect(with: configuration) { _ in
      sut.disconnect(from: configuration.ssid)
      sut.hotspotManager.getConfiguredSSIDs { configuredSSIDs in
        SSIDs = configuredSSIDs
        exp.fulfill()
      }
    }
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertFalse(SSIDs.contains(configuration.ssid))
  }
}

// MARK: - Private
private extension HotspotClientTests {
  var anyConfiguration: HotspotConfiguration {
    HotspotConfiguration(ssid: "anySSID", password: "anyPassword", isWEP: false)
  }
  
  func makeSUT(manager: NEHotspotConfigurationManager = .shared) -> NEHotspotClient {
    let sut = NEHotspotClient(hotspotManager: manager)
    return sut
  }
}
