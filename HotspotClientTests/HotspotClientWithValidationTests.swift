//
//  HotspotClientWithValidationTests.swift
//  HotspotClientTests
//
//  Created by Marko Engelman on 14/08/2021.
//

import XCTest
@testable import HotspotClient

class HotspotClientWithValidationTests: XCTestCase {
  func test_init_hasNoSideEffects_onClient() {
    let (_, client) = makeSUT()
    XCTAssertFalse(client.connectTriggered)
  }
  
  func test_connect_hasNoSideEffectsOnConfiguration() {
    let (sut, client) = makeSUT()
    let configuration = anyConfiguration
    sut.connect(with: configuration) { _ in }
    XCTAssertEqual(client.configuration?.password, configuration.password)
    XCTAssertEqual(client.configuration?.ssid, configuration.ssid)
    XCTAssertEqual(client.configuration?.isWEP, configuration.isWEP)
  }
  
  func test_disconnect_triggers_client() {
    let (sut, client) = makeSUT()
    sut.disconnect(from: anyConfiguration.ssid)
    XCTAssertTrue(client.disconnectTriggered)
  }
}

// MARK: - Private
private extension HotspotClientWithValidationTests {
  var anyConfiguration: HotspotConfiguration {
    HotspotConfiguration(ssid: "anySSID", password: "anyPassword", isWEP: false)
  }
  
  class HotspotClientMock: HotspotClient {
    var configuration: HotspotConfiguration?
    var connectTriggered: Bool { configuration != nil }
    var disconnectTriggered: Bool = false
    
    func connect(with configuration: HotspotConfiguration, completion: @escaping (HotspotClient.Result) -> Void) {
      self.configuration = configuration
    }
    
    func disconnect(from SSID: String) {
      disconnectTriggered = true
    }
  }
  
  func makeSUT() -> (HotspotClientWithValidation, HotspotClientMock) {
    let client = HotspotClientMock()
    let sut = HotspotClientWithValidation(client: client)
    return (sut, client)
  }
}
