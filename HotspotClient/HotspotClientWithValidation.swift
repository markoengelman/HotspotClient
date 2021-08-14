//
//  HotspotClientWithValidation.swift
//  HotspotClient
//
//  Created by Marko Engelman on 14/08/2021.
//

import Foundation

class HotspotClientWithValidation {
  let client: HotspotClient
  let ssidLoader: SSIDLoader
  
  init(client: HotspotClient, ssidLoader: SSIDLoader) {
    self.client = client
    self.ssidLoader = ssidLoader
  }
}

// MARK: - HotspotClient
extension HotspotClientWithValidation: HotspotClient {
  func connect(with cofiguration: HotspotConfiguration, completion: @escaping (HotspotClient.Result) -> Void) {
    client.connect(with: cofiguration, completion: completion)
  }
  
  func disconnect(from SSID: String) {
    client.disconnect(from: SSID)
  }
}
