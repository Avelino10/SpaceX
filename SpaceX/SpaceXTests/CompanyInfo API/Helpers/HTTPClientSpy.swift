//
//  HTTPClientSpy.swift
//  SpaceXTests
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import Foundation
import SpaceX

class HTTPClientSpy: HTTPClient {
    private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }

    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        messages.append((url, completion))
    }

    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }

    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(url: messages[index].url, statusCode: code, httpVersion: nil, headerFields: nil)!

        messages[index].completion(.success((data, response)))
    }
}
