//
//  XCTest+Helpers.swift
//  XCTest+Helpers
//
//  Created by Marko Engelman on 15/08/2021.
//

import XCTest
@testable import HotspotClient

extension XCTest {
  var anyConfiguration: HotspotConfiguration {
    HotspotConfiguration(ssid: "anySSID", password: "anyPassword", isWEP: false, joincOnce: true)
  }
}
