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
  public let joinOnce: Bool
  
  @available(iOS, introduced: 11, obsoleted: 14, message: "Deprecated initialiser on iOS15. Please use init(ssid: String, password: String, isWEP: Bool)")
  public init(ssid: String, password: String, isWEP: Bool, joinOnce: Bool) {
    self.ssid = ssid
    self.password = password
    self.isWEP = isWEP
    self.joinOnce = joinOnce
  }
    
  @available(iOS, introduced: 15)
  public init(ssid: String, password: String, isWEP: Bool) {
    self.ssid = ssid
    self.password = password
    self.isWEP = isWEP
    self.joinOnce = false
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
