//
//  RemoteLaunchImageDataLoader.swift
//  SpaceX
//
//  Created by Avelino Rodrigues on 20/09/2021.
//

import Foundation

public class RemoteLaunchImageDataLoader: LaunchImageDataLoader {
    let client: HTTPClient
    public init(client: HTTPClient) {
        self.client = client
    }

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    private final class HTTPClientTaskWrapper: LaunchImageDataLoaderTask {
        private var completion: ((LaunchImageDataLoader.Result) -> Void)?

        var wrapper: HTTPClientTask?

        init(_ completion: @escaping (LaunchImageDataLoader.Result) -> Void) {
            self.completion = completion
        }

        func complete(with result: LaunchImageDataLoader.Result) {
            completion?(result)
        }

        func cancel() {
            preventFurtherCompletions()
            wrapper?.cancel()
        }

        private func preventFurtherCompletions() {
            completion = nil
        }
    }

    public func loadImageData(from url: URL, completion: @escaping (LaunchImageDataLoader.Result) -> Void) -> LaunchImageDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapper = client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            task.complete(with: result
                .mapError { _ in Error.connectivity }
                .flatMap { data, response in
                    let isValidResponse = response.isOK && !data.isEmpty
                    return isValidResponse ? .success(data) : .failure(Error.invalidData)
                })
        }

        return task
    }
}
