//
//  RemoteCompanyInfoLoaderTests.swift
//  SpaceXTests
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import XCTest

class RemoteCompanyInfoLoader {
    private let client: HTTPClient
    let url: URL

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class RemoteCompanyInfoLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()

        XCTAssertEqual(client.requestedURL, url)
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteCompanyInfoLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCompanyInfoLoader(url: url, client: client)

        return (sut, client)
    }

    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?

        func get(from url: URL) {
            requestedURL = url
        }
    }
}
