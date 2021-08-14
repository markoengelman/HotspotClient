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
  
  typealias Completion = (HotspotClient.Result) -> Void
  
  init(client: HotspotClient, ssidLoader: SSIDLoader) {
    self.client = client
    self.ssidLoader = ssidLoader
  }
}

// MARK: - HotspotClient
extension HotspotClientWithValidation: HotspotClient {
  func connect(with configuration: HotspotConfiguration, completion: @escaping Completion) {
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
  func findMatchingSSID(from configuration: HotspotConfiguration, completion: @escaping Completion) {
    retry(with: 0, configuration: configuration, completion: completion)
  }
  
  func retry(with retryCount: Int, configuration: HotspotConfiguration, completion: @escaping Completion) {
    ssidLoader.load { [weak self] SSIDs in
      if SSIDs.contains(configuration.ssid) {
        completion(.success(()))
      } else if HotspotClientValidationPolicy.validateRetryCount(against: retryCount) {
        self?.retry(with: retryCount + 1, configuration: configuration, completion: completion)
      } else {
        completion(.failure(ValidationError.couldNotValidateSSID))
      }
    }
  }
}
