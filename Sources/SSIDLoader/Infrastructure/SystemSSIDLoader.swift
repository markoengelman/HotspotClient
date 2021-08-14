//
//  SystemSSIDLoader.swift
//  HotspotClient
//
//  Created by Marko Engelman on 14/08/2021.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import NetworkExtension

public class SystemSSIDLoader {
  public init() { }
  
  @available(iOS, deprecated: 14.0, obsoleted: 14.0, message: "API is deprecated and obsoleted in iOS 14.0, use 'fetchCurrentNetwork' instead.")
  func compyInterfaces() -> [String] {
    guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else { return [] }
    let infterfaces = interfaceNames.compactMap { name -> String? in
        guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String: AnyObject] else { return nil }
        guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else { return nil }
        return ssid
    }
    return infterfaces
  }
  
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
  public func load(completion: @escaping ([String]) -> Void) {
    if #available(iOS 14.0, *) {
      fetchCurrentNetwork(completion: completion)
    } else {
      completion(compyInterfaces())
    }
  }
}
