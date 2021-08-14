//
//  HEHotspotClient.swift
//  HotspotClient
//
//  Created by Marko Engelman on 13/08/2021.
//

import Foundation
import NetworkExtension

class NEHotspotClient {
  let hotspotManager: NEHotspotConfigurationManager
  
  init(hotspotManager: NEHotspotConfigurationManager) {
    self.hotspotManager = hotspotManager
  }
  
  static func mapError(error: NSError) -> HotspotClientError {
    switch error.code {
    case NEHotspotConfigurationError.alreadyAssociated.rawValue: return .alreadyConnected
    case NEHotspotConfigurationError.userDenied.rawValue: return .userDeniedConnection
    default: return .other(error: error)
    }
  }
}

// MARK: - HotspotClient
extension NEHotspotClient: HotspotClient {
  func connect(with cofiguration: HotspotConfiguration, completion: @escaping (HotspotClient.Result) -> Void) {
    let hotspotConfiguration = NEHotspotConfiguration(ssid: cofiguration.ssid, passphrase: cofiguration.password, isWEP: cofiguration.isWEP)
    hotspotManager.apply(hotspotConfiguration) { error in
      completion(Result { if let error = error { throw Self.mapError(error: error as NSError) } })
    }
  }
  
  func disconnect(from SSID: String) {
    hotspotManager.removeConfiguration(forSSID: SSID)
  }
}