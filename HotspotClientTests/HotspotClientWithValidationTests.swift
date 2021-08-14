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
}

// MARK: - Private
private extension HotspotClientWithValidationTests {
  class HotspotClientMock: HotspotClient {
    var connectTriggered: Bool = false
    
    func connect(with cofiguration: HotspotConfiguration, completion: @escaping (HotspotClient.Result) -> Void) {
      connectTriggered = true
    }
    
    func disconnect(from SSID: String) {
      
    }
  }
  
  func makeSUT() -> (HotspotClientWithValidation, HotspotClientMock) {
    let client = HotspotClientMock()
    let sut = HotspotClientWithValidation(client: client)
    return (sut, client)
  }
}
