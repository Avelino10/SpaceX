//
//  RemoteCompanyInfoLoader.swift
//  SpaceX
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import Foundation

public class RemoteCompanyInfoLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public enum Result: Equatable {
        case success(CompanyInfo)
        case failure(Error)
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in

            switch result {
                case let .success(data, response):
                    if response.statusCode == 200, let info = try? JSONDecoder().decode(Info.self, from: data) {
                        completion(.success(info.companyInfo))
                    } else {
                        completion(.failure(.invalidData))
                    }
                case .failure:
                    completion(.failure(.connectivity))
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
