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
  func connect(with configuration: HotspotConfiguration, completion: @escaping (HotspotClient.Result) -> Void) {
    client.connect(with: configuration) { [weak self] result in
      switch result {
      case .success:
        self?.ssidLoader.load { SSIDs in
          guard SSIDs.contains(configuration.ssid) else { return }
          completion(.success(()))
        }
        
      case .failure:
        completion(result)
      }
    }
  }
  
  func disconnect(from SSID: String) {
    client.disconnect(from: SSID)
  }
}
