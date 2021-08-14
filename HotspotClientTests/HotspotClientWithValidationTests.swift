//
//  HotspotClientWithValidationTests.swift
//  HotspotClientTests
//
//  Created by Marko Engelman on 14/08/2021.
//

import XCTest
@testable import HotspotClient

class HotspotClientWithValidationTests: XCTestCase {
  func test_init_hasNoSideEffects_onClient_andSSIDLoader() {
    let (_, client, loader) = makeSUT()
    XCTAssertFalse(client.connectTriggered)
    XCTAssertFalse(loader.loadTriggered)
  }
  
  func test_connect_hasNoSideEffectsOnConfiguration() {
    let (sut, client, _) = makeSUT()
    let configuration = anyConfiguration
    sut.connect(with: configuration) { _ in }
    XCTAssertEqual(client.configuration?.password, configuration.password)
    XCTAssertEqual(client.configuration?.ssid, configuration.ssid)
    XCTAssertEqual(client.configuration?.isWEP, configuration.isWEP)
  }
  
  func test_disconnect_hasNoSideEffectsOnSSID() {
    let (sut, client, _) = makeSUT()
    let ssid = anyConfiguration.ssid
    sut.disconnect(from: ssid)
    XCTAssertEqual(client.disconnectedSSID, ssid)
  }
}

// MARK: - Private
private extension HotspotClientWithValidationTests {
  var anyConfiguration: HotspotConfiguration {
    HotspotConfiguration(ssid: "anySSID", password: "anyPassword", isWEP: false)
  }
  
  class HotspotClientMock: HotspotClient {
    var configuration: HotspotConfiguration?
    var disconnectedSSID: String?
    var connectTriggered: Bool { configuration != nil }
    
    func connect(with configuration: HotspotConfiguration, completion: @escaping (HotspotClient.Result) -> Void) {
      self.configuration = configuration
    }
    
    func disconnect(from SSID: String) {
      disconnectedSSID = SSID
    }
  }
  
  class SSIDLoaderMock: SSIDLoader {
    var loadTriggered: Bool = false
    
    func load(completion: @escaping ([String]) -> Void) {
      loadTriggered = true
    }
  }
  
  func makeSUT() -> (HotspotClientWithValidation, HotspotClientMock, SSIDLoaderMock) {
    let client = HotspotClientMock()
    let loader = SSIDLoaderMock()
    let sut = HotspotClientWithValidation(client: client, ssidLoader: loader)
    return (sut, client, loader)
  }
}
