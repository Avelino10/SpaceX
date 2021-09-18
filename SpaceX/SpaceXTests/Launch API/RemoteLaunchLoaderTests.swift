//
//  RemoteLaunchLoaderTests.swift
//  SpaceXTests
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import SpaceX
import XCTest

class RemoteLaunchLoader {
    private let url: URL
    private let client: HTTPClient

    init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }

    func load() {
        client.get(from: url) { _ in
        }
    }
}

class RemoteLaunchLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()
        sut.load()

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteLaunchLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLaunchLoader(url: url, client: client)

        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, client)
    }
}
