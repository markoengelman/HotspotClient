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
