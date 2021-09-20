//
//  LaunchImageDataLoader.swift
//  SpaceXiOS
//
//  Created by Avelino Rodrigues on 20/09/2021.
//

import Foundation

public protocol LaunchImageDataLoaderTask {
    func cancel()
}

public protocol LaunchImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> LaunchImageDataLoaderTask
}
