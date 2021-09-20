//
//  LaunchesViewControllerTests.swift
//  SpaceXiOSTests
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import SpaceX
import UIKit
import XCTest

final class LaunchesViewController: UIViewController {
    private var loader: LaunchLoader?
    convenience init(loader: LaunchLoader) {
        self.init()
        self.loader = loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loader?.load { _ in }
    }
}

final class LaunchesViewControllerTests: XCTestCase {
    func test_init_doesNotLoadLaunches() {
        let (_, loader) = makeSUT()

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    func test_viewDidLoad_loadsLaunches() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.loadCallCount, 1)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LaunchesViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = LaunchesViewController(loader: loader)

        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, loader)
    }

    class LoaderSpy: LaunchLoader {
        private(set) var loadCallCount: Int = 0

        func load(completion: @escaping (LaunchLoader.Result) -> Void) {
            loadCallCount += 1
        }
    }
}
