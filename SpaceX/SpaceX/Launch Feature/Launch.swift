//
//  Launch.swift
//  SpaceX
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import Foundation

public struct Link: Equatable {
    public let missionPatch: String
}

public struct Rocket: Equatable {
    public let name: String
    public let type: String
}

public struct Launch: Equatable {
    public let missionName: String
    public let launchDate: Date
    public let launchSuccess: Bool
    public let rocket: Rocket
    public let links: Link

    public init(missionName: String, launchDate: Date, launchSuccess: Bool, rocket: Rocket, links: Link) {
        self.missionName = missionName
        self.launchDate = launchDate
        self.launchSuccess = launchSuccess
        self.rocket = rocket
        self.links = links
    }
}
