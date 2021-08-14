//
//  SSIDLoader.swift
//  HotspotClient
//
//  Created by Marko Engelman on 13/08/2021.
//

import Foundation

public protocol SSIDLoader {
  func load(completion: @escaping ([String]) -> Void)
}
