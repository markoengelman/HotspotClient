//
//  HotspotClientTests.swift
//  HotspotClientTests
//
//  Created by Marko Engelman on 13/08/2021.
//

import XCTest
@testable import HotspotClient

class NEHotspotClient: HotspotClient {
  func connect(with cofiguration: HotspotConfiguration, completion: @escaping (HotspotClient.Result) -> Void) {
    
  }
  
  func disconnect(from SSID: String) {
    
  }
}

class HotspotClientTests: XCTestCase {
    
}
