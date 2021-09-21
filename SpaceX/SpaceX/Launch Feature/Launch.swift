//
//  Launch.swift
//  SpaceX
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import Foundation

public struct Link: Equatable {
    public let image: URL?
    public let article: URL?
    public let wikipedia: URL?
    public let video: URL?

    public init(image: URL?, article: URL?, wikipedia: URL?, video: URL?) {
        self.image = image
        self.article = article
        self.wikipedia = wikipedia
        self.video = video
    }
}

public struct Rocket: Equatable {
    public let name: String
    public let type: String

    public init(name: String, type: String) {
        self.name = name
        self.type = type
    }
}

public struct Launch: Equatable {
    public let missionName: String
    public let launchDate: String
    public let launchSuccess: Bool
    public let rocket: Rocket
    public let links: Link

    public init(missionName: String, launchDate: String, launchSuccess: Bool, rocket: Rocket, links: Link) {
        self.missionName = missionName
        self.launchDate = launchDate
        self.launchSuccess = launchSuccess
        self.rocket = rocket
        self.links = links
    }
}
