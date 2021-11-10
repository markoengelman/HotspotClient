//
//  HEHotspotClientTests.swift
//  HEHotspotClientTests
//
//  Created by Marko Engelman on 13/08/2021.
//

import XCTest
import NetworkExtension
@testable import HotspotClient

class HEHotspotClientTests: XCTestCase {
  @available(iOS 15, *)
  func test_init_hasNoSideEffectsOn_iOS15Configuration() {
    let sut = HotspotConfiguration(ssid: anyConfiguration.ssid, password: anyConfiguration.password, isWEP: anyConfiguration.isWEP)
    XCTAssertEqual(sut.ssid, anyConfiguration.ssid)
    XCTAssertEqual(sut.password, anyConfiguration.password)
    XCTAssertEqual(sut.isWEP, anyConfiguration.isWEP)
    XCTAssertEqual(sut.joinOnce, false)
  }
  
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
  
  func test_mapError_mapsHotspotErrors() {
    XCTAssertEqual(NEHotspotClient.mapError(error: makeError(for: .alreadyAssociated)), .alreadyConnected)
    XCTAssertEqual(NEHotspotClient.mapError(error: makeError(for: .userDenied)), .userDeniedConnection)
    XCTAssertEqual(NEHotspotClient.mapError(error: makeError(for: .applicationIsNotInForeground)), .other(error: makeError(for: .applicationIsNotInForeground)))
  }
}

// MARK: - Private
private extension HEHotspotClientTests {
  func makeSUT(manager: NEHotspotConfigurationManager = .shared) -> NEHotspotClient {
    let sut = NEHotspotClient(hotspotManager: manager)
    return sut
  }
  
  func makeError(for code: NEHotspotConfigurationError) -> NSError {
    NSError(domain: NEHotspotConfigurationErrorDomain, code: code.rawValue, userInfo: [:])
  }
}
