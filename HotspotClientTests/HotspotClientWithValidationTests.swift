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
  
  func test_connect_triggers_client() {
    let (sut, client) = makeSUT()
    sut.connect(with: anyConfiguration) { _ in }
    XCTAssertTrue(client.connectTriggered)
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
    var connectTriggered: Bool = false
    var disconnectTriggered: Bool = false
    
    func connect(with cofiguration: HotspotConfiguration, completion: @escaping (HotspotClient.Result) -> Void) {
      connectTriggered = true
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
