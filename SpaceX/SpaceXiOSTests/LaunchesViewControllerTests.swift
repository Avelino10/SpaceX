//
//  LaunchesViewControllerTests.swift
//  SpaceXiOSTests
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import SpaceX
import SpaceXiOS
import XCTest

final class LaunchesViewControllerTests: XCTestCase {
    func test_init_doesNotLoadLaunches() {
        let (_, launchLoader, companyInfoLoader) = makeSUT()

        XCTAssertEqual(launchLoader.loadLaunchCallCount, 0)
        XCTAssertEqual(companyInfoLoader.loadCompanyInfoCallCount, 0)
    }

    func test_viewDidLoad_loadsLaunchesAndCompanyInfo() {
        let (sut, launchLoader, companyInfoLoader) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(launchLoader.loadLaunchCallCount, 1)
        XCTAssertEqual(companyInfoLoader.loadCompanyInfoCallCount, 1)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LaunchesViewController, launchLoader: LoaderSpy, companyInfoLoader: LoaderSpy) {
        let launchLoader = LoaderSpy()
        let companyInfoLoader = LoaderSpy()
        let sut = LaunchesViewController(companyInfoLoader: companyInfoLoader, launchLoader: launchLoader)

        trackForMemoryLeaks(launchLoader, file: file, line: line)
        trackForMemoryLeaks(companyInfoLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, launchLoader, companyInfoLoader)
    }

    class LoaderSpy: LaunchLoader, CompanyInfoLoader {
        private(set) var loadLaunchCallCount: Int = 0
        private(set) var loadCompanyInfoCallCount: Int = 0

        func load(completion: @escaping (LaunchLoader.Result) -> Void) {
            loadLaunchCallCount += 1
        }

        func load(completion: @escaping (CompanyInfoLoader.Result) -> Void) {
            loadCompanyInfoCallCount += 1
        }
    }
}
