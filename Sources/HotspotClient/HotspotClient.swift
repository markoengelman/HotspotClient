//
//  HotspotClient.swift
//  HotspotClient
//
//  Created by Marko Engelman on 13/08/2021.
//

import Foundation

public struct HotspotConfiguration {
  public let ssid: String
  public let password: String
  public let isWEP: Bool
  public let joincOnce: Bool
  
  public init(ssid: String, password: String, isWEP: Bool, joincOnce: Bool) {
    self.ssid = ssid
    self.password = password
    self.isWEP = isWEP
    self.joincOnce = joincOnce
  }
}

public enum HotspotClientError: Error, Equatable {
  case alreadyConnected
  case userDeniedConnection
  case other(error: NSError)
}

public protocol HotspotClient {
  typealias Result = Swift.Result<Void, Error>
  
  func connect(with configuration: HotspotConfiguration, completion: @escaping (Result) -> Void)
  func disconnect(from SSID: String)
}
