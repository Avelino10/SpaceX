//
//  LaunchesViewControllerTests.swift
//  SpaceXiOSTests
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import SpaceX
import SpaceXiOS
import UIKit
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

    func test_loadLaunchCompletion_rendersSuccessfullyLoadedLaunch() {
        let mission0 = makeMission(name: "mission0", rocketName: "rocket0")
        let mission1 = makeMission(name: "mission1", rocketName: "rocket1")
        let mission2 = makeMission(name: "mission2", rocketName: "rocket2")
        let mission3 = makeMission(name: "mission3", rocketName: "rocket3")
        let (sut, launchLoader, _) = makeSUT()

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])

        launchLoader.completeLaunchLoading(with: [mission0, mission1, mission2, mission3], at: 0)
        assertThat(sut, isRendering: [mission0, mission1, mission2, mission3])
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

    private func assertThat(_ sut: LaunchesViewController, isRendering launch: [Launch], file: StaticString = #filePath, line: UInt = #line) {
        guard sut.numberOfRenderedLaunchImageViews() == launch.count else {
            return XCTFail("Expected \(launch.count) images, got \(sut.numberOfRenderedLaunchImageViews()) instead.", file: file, line: line)
        }

        launch.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }

    private func assertThat(_ sut: LaunchesViewController, hasViewConfiguredFor launch: Launch, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.launchImageView(at: index)

        guard let cell = view as? LaunchCell else {
            return XCTFail("Expected \(LaunchCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        XCTAssertEqual(cell.missionNameText, launch.missionName, "Expected name text to be \(String(describing: launch.missionName)) for launch view at index (\(index))", file: file, line: line)

        XCTAssertEqual(cell.missionDateText, launch.launchDate, "Expected date text to be \(String(describing: launch.launchDate)) for launch view at index (\(index))", file: file, line: line)

        XCTAssertEqual(cell.rocketInfoText, "\(launch.rocket.name)/\(launch.rocket.type)", "Expected rocket info text to be \(String(describing: "\(launch.rocket.name)/\(launch.rocket.type)")) for launch view at index (\(index))", file: file, line: line)
    }

    private func makeMission(name: String, rocketName: String) -> Launch {
        let rocket = Rocket(name: rocketName, type: "type-\(rocketName)")
        return Launch(missionName: name, launchDate: "2021/20/09", launchSuccess: true, rocket: rocket, links: Link(missionPatch: URL(string: "http://a-url.com")!))
    }

    class LoaderSpy: LaunchLoader, CompanyInfoLoader {
        private var launchCompletions = [(LaunchLoader.Result) -> Void]()
        private var companyInfoCompletions = [(CompanyInfoLoader.Result) -> Void]()

        var loadLaunchCallCount: Int {
            launchCompletions.count
        }

        var loadCompanyInfoCallCount: Int {
            companyInfoCompletions.count
        }

        func load(completion: @escaping (LaunchLoader.Result) -> Void) {
            launchCompletions.append(completion)
        }

        func load(completion: @escaping (CompanyInfoLoader.Result) -> Void) {
            companyInfoCompletions.append(completion)
        }

        func completeLaunchLoading(with launch: [Launch] = [], at index: Int) {
            launchCompletions[index](.success(launch))
        }
    }
}

private extension LaunchesViewController {
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
}

private extension LaunchCell {
    var missionNameText: String? {
        missionName.text
    }

    var missionDateText: String? {
        missionDate.text
    }

    var rocketInfoText: String? {
        rocketInfo.text
    }
}
