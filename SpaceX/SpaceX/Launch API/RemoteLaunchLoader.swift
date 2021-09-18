//
//  RemoteLaunchLoader.swift
//  SpaceX
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import Foundation

public class RemoteLaunchLoader {
    private let url: URL
    private let client: HTTPClient

    public typealias Result = LaunchLoader.Result

    public enum Error: Swift.Error {
        case invalidData
        case connectivity
    }

    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
                case let .success((data, _)):
                    if let apiLaunch = try? JSONDecoder().decode([APILaunch].self, from: data) {
                        completion(.success(apiLaunch.map { $0.launch }))
                    } else {
                        completion(.failure(Error.invalidData))
                    }
                case .failure:
                    completion(.failure(Error.connectivity))
            }
        }
    }
}

private struct APILaunch: Decodable {
    let mission_name: String
    let launch_date_utc: String
    let launch_success: Bool
    let rocket: APIRocket
    let links: APILink

    var launch: Launch {
        let rocket = Rocket(name: self.rocket.rocket_name, type: self.rocket.rocket_type)
        let link = Link(missionPatch: links.mission_patch)

        return Launch(missionName: mission_name, launchDate: launch_date_utc, launchSuccess: launch_success, rocket: rocket, links: link)
    }
}

private struct APIRocket: Decodable {
    let rocket_name: String
    let rocket_type: String
}

private struct APILink: Decodable {
    let mission_patch: URL
}
