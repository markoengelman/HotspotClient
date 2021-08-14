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
  
  func test_connect_hasNoSideEffectsOnSSIDLoader_onClientFailure() {
    let (sut, client, loader) = makeSUT()
    client.complete(with: .failure(anyError))
    
    let exp = expectation(description: "Waiting for connect")
    sut.connect(with: anyConfiguration) { _ in exp.fulfill() }
    wait(for: [exp], timeout: 1.0)
    
    XCTAssertFalse(loader.loadTriggered)
  }
  
  func test_connect_deliversSuccess_onClientSuccess_andLoadedSSID() throws {
    let (sut, client, loader) = makeSUT()
    let configuration = anyConfiguration
    client.complete(with: .success(()))
    loader.complete(with: [configuration.ssid])
    
    var result: HotspotClient.Result?
    let exp = expectation(description: "Waiting for connect")
    sut.connect(with: configuration) { receivedResult in
      result = receivedResult
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
    
    XCTAssertNoThrow(try result?.get())
  }
}

// MARK: - Private
private extension HotspotClientWithValidationTests {
  var anyConfiguration: HotspotConfiguration {
    HotspotConfiguration(ssid: "anySSID", password: "anyPassword", isWEP: false)
  }
  
  var anyError: NSError {
    NSError(domain: "", code: 1, userInfo: nil)
  }
  
  class HotspotClientMock: HotspotClient {
    var configuration: HotspotConfiguration?
    var result: (HotspotClient.Result)?
    var disconnectedSSID: String?
    var connectTriggered: Bool { configuration != nil }
    
    func connect(with configuration: HotspotConfiguration, completion: @escaping (HotspotClient.Result) -> Void) {
      self.configuration = configuration
      if let result = result {
        completion(result)
      }
    }
    
    func disconnect(from SSID: String) {
      disconnectedSSID = SSID
    }
    
    func complete(with result: HotspotClient.Result) {
      self.result = result
    }
  }
  
  class SSIDLoaderMock: SSIDLoader {
    var loadTriggered: Bool = false
    var SSIDs: [String]?
    
    func load(completion: @escaping ([String]) -> Void) {
      loadTriggered = true
      if let SSIDs = SSIDs {
        completion(SSIDs)
      } else {
        completion([])
      }
    }
    
    func complete(with SSIDs: [String]) {
      self.SSIDs = SSIDs
    }
  }
  
  func makeSUT() -> (HotspotClientWithValidation, HotspotClientMock, SSIDLoaderMock) {
    let client = HotspotClientMock()
    let loader = SSIDLoaderMock()
    let sut = HotspotClientWithValidation(client: client, ssidLoader: loader)
    return (sut, client, loader)
  }
}
