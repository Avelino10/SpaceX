//
//  LaunchesViewControllerTests.swift
//  SpaceXiOSTests
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import XCTest

final class LaunchesViewController {
    init(loader: LaunchesViewControllerTests.LoaderSpy) {
    }
}

final class LaunchesViewControllerTests: XCTestCase {
    func test_init_doesNotLoadLaunches() {
        let loader = LoaderSpy()
        _ = LaunchesViewController(loader: loader)

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    // MARK: - Helpers

    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}
