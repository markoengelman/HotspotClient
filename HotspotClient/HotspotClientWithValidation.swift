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
  
  enum ValidationError: Error {
    case couldNotValidateSSID
  }
  
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
        self?.findMatchingSSID(from: configuration, completion: completion)
        
      case .failure:
        completion(result)
      }
    }
  }
  
  func disconnect(from SSID: String) {
    client.disconnect(from: SSID)
  }
}

// MARK: - Private
private extension HotspotClientWithValidation {
  func findMatchingSSID(from configuration: HotspotConfiguration, completion: @escaping (HotspotClient.Result) -> Void) {
    ssidLoader.load { SSIDs in
      SSIDs.contains(configuration.ssid)
        ? completion(.success(()))
        : completion(.failure(ValidationError.couldNotValidateSSID))
    }
  }
}
