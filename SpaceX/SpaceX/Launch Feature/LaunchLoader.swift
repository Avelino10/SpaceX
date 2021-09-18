//
//  LaunchLoader.swift
//  SpaceX
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import Foundation

public protocol LaunchLoader {
    typealias Result = Swift.Result<[Launch], Error>

    func load(completion: @escaping (Result) -> Void)
}
