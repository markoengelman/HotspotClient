//
//  HotspotClientValidationPolicy.swift
//  HotspotClient
//
//  Created by Marko Engelman on 14/08/2021.
//

import Foundation

final class HotspotClientValidationPolicy {
  static let maxRetryCount = 3
  
  static func validateRetryCount(against currentCount: Int) -> Bool {
    return maxRetryCount >= currentCount
  }
}