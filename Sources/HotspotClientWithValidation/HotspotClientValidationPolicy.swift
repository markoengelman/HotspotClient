//
//  HotspotClientValidationPolicy.swift
//  HotspotClient
//
//  Created by Marko Engelman on 14/08/2021.
//

import Foundation

public final class HotspotClientValidationPolicy {
  private init() { }
  
  public static let maxRetryCount = 3
  
  public static func validateRetryCount(against currentCount: Int) -> Bool {
    return maxRetryCount >= currentCount
  }
}
