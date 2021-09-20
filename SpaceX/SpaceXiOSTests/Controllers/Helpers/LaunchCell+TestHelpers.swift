//
//  LaunchCell+TestHelpers.swift
//  SpaceXiOSTests
//
//  Created by Avelino Rodrigues on 20/09/2021.
//

import Foundation
import SpaceXiOS

extension LaunchCell {
    var missionNameText: String? {
        missionName.text
    }

    var missionDateText: String? {
        missionDate.text
    }

    var rocketInfoText: String? {
        rocketInfo.text
    }

    var renderedImage: Data? {
        missionImage.image?.pngData()
    }
}
