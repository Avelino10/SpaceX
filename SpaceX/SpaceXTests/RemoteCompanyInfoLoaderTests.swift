//
//  RemoteCompanyInfoLoaderTests.swift
//  SpaceXTests
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import XCTest

class RemoteCompanyInfoLoader {}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteCompanyInfoLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteCompanyInfoLoader()

        XCTAssertNil(client.requestedURL)
    }
}
