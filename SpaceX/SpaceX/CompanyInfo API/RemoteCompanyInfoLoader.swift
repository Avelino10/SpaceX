//
//  RemoteCompanyInfoLoader.swift
//  SpaceX
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import Foundation

public class RemoteCompanyInfoLoader: CompanyInfoLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public typealias Result = LoadCompanyResult

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
                case let .success(data, response):
                    if response.statusCode == 200, let info = try? JSONDecoder().decode(Info.self, from: data) {
                        completion(.success(info.companyInfo))
                    } else {
                        completion(.failure(Error.invalidData))
                    }
                case .failure:
                    completion(.failure(Error.connectivity))
            }
        }
    }
}

private struct Info: Decodable {
    let name: String
    let founder: String
    let founded: Int
    let employees: Int
    let launch_sites: Int
    let valuation: Int

    var companyInfo: CompanyInfo {
        CompanyInfo(companyName: name, founderName: founder, year: founded, employees: employees, launchSites: launch_sites, valuation: valuation)
    }
}
