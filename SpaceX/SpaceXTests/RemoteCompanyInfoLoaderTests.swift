//
//  RemoteCompanyInfoLoaderTests.swift
//  SpaceXTests
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import XCTest

class RemoteCompanyInfoLoader {
    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func load() {
        client.requestedURL = URL(string: "https://a-url.com")
    }
}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteCompanyInfoLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteCompanyInfoLoader(client: client)

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestDataFromURL() {
        let client = HTTPClient()
        let sut = RemoteCompanyInfoLoader(client: client)

        sut.load()

        XCTAssertNotNil(client.requestedURL)
    }
}
