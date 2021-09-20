//
//  LaunchesViewController+TestHelpers.swift
//  SpaceXiOSTests
//
//  Created by Avelino Rodrigues on 20/09/2021.
//

import SpaceXiOS
import UIKit

extension LaunchesViewController {
    func numberOfRenderedLaunchImageViews() -> Int {
        tableView.numberOfRows(inSection: launchImagesSection)
    }

    func launchImageView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: launchImagesSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }

    private var launchImagesSection: Int {
        0
    }

    @discardableResult
    func simulateLaunchImageViewVisible(at index: Int) -> LaunchCell? {
        launchImageView(at: index) as? LaunchCell
    }

    func simulateLaunchImageViewNotVisible(at row: Int) {
        let view = simulateLaunchImageViewVisible(at: row)

        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: launchImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
    }
}
