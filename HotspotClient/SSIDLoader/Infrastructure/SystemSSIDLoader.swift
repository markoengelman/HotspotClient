//
//  SystemSSIDLoader.swift
//  HotspotClient
//
//  Created by Marko Engelman on 14/08/2021.
//

import Foundation
import NetworkExtension

class SystemSSIDLoader {
  @available(iOS 14.0, *)
  func fetchCurrentNetwork(completion: @escaping ([String]) -> Void) {
    NEHotspotNetwork.fetchCurrent { network in
        guard let network = network else { return completion([]) }
        completion([network.ssid])
    }
  }
}

// MARK: - SSIDLoader
extension SystemSSIDLoader: SSIDLoader {
  func load(completion: @escaping ([String]) -> Void) {
    if #available(iOS 14.0, *) {
        fetchCurrentNetwork(completion: completion)
    }
  }
}
