//
//  RemoteCompanyInfoLoader.swift
//  SpaceX
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public class RemoteCompanyInfoLoader {
    private let client: HTTPClient
    let url: URL

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load() {
        client.get(from: url)
    }
}
