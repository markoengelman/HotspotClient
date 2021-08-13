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
}

// MARK: - Private
private extension HotspotClientTests {
  func makeSUT(manager: NEHotspotConfigurationManager = .shared) -> NEHotspotClient {
    let sut = NEHotspotClient(hotspotManager: manager)
    return sut
  }
}
