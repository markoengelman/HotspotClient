//
//  HotspotClientTests.swift
//  HotspotClientTests
//
//  Created by Marko Engelman on 13/08/2021.
//

import XCTest
import NetworkExtension
@testable import HotspotClient

class NEHotspotClient: HotspotClient {
  let hotspotManager: NEHotspotConfigurationManager
  
  init(hotspotManager: NEHotspotConfigurationManager) {
    self.hotspotManager = hotspotManager
  }
  
  func connect(with cofiguration: HotspotConfiguration, completion: @escaping (HotspotClient.Result) -> Void) {
    let hotspotConfiguration = NEHotspotConfiguration(ssid: cofiguration.ssid, passphrase: cofiguration.password, isWEP: cofiguration.isWEP)
    hotspotManager.apply(hotspotConfiguration) { error in
      completion(Result { if let error = error { throw error } })
    }
  }
  
  func disconnect(from SSID: String) {
    
  }
}

class HotspotClientTests: XCTestCase {
  func test_init_hasNoSideEffectsOnHotspotManger() {
    let manager = NEHotspotConfigurationManager()
    let sut = makeSUT(manager: manager)
    XCTAssertEqual(manager, sut.hotspotManager)
  }
  
  func test_connect_eventuallyDeliversResult() {
    let sut = makeSUT()
    let configuration = HotspotConfiguration(ssid: "anySSID", password: "anyPassword", isWEP: false)
    let exp = expectation(description: "Waiting for result")
    sut.connect(with: configuration) { result in
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
  }
}

// MARK: - Private
private extension HotspotClientTests {
  func makeSUT(manager: NEHotspotConfigurationManager = .shared) -> NEHotspotClient {
    let sut = NEHotspotClient(hotspotManager: manager)
    return sut
  }
}
