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
        let (_, loader) = makeSUT()

        XCTAssertEqual(loader.loadLaunchCallCount, 0)
        XCTAssertEqual(loader.loadCompanyInfoCallCount, 0)
    }

    func test_viewDidLoad_loadsLaunchesAndCompanyInfo() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.loadLaunchCallCount, 1)
        XCTAssertEqual(loader.loadCompanyInfoCallCount, 1)
    }

    func test_loadLaunchCompletion_rendersSuccessfullyLoadedLaunch() {
        let mission0 = makeMission(name: "mission0", rocketName: "rocket0")
        let mission1 = makeMission(name: "mission1", rocketName: "rocket1")
        let mission2 = makeMission(name: "mission2", rocketName: "rocket2")
        let mission3 = makeMission(name: "mission3", rocketName: "rocket3")
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])

        loader.completeLaunchLoading(with: [mission0, mission1, mission2, mission3])
        assertThat(sut, isRendering: [mission0, mission1, mission2, mission3])
    }

    func test_launchImageView_loadsImageURLWhenVisible() {
        let mission0 = makeMission(name: "mission0", rocketName: "rocket0", url: URL(string: "http://url-0.com")!)
        let mission1 = makeMission(name: "mission1", rocketName: "rocket1", url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeLaunchLoading(with: [mission0, mission1])
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")

        sut.simulateLaunchImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [mission0.links.missionPatch], "Expected first image URL requests once first view becomes visible")

        sut.simulateLaunchImageViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [mission0.links.missionPatch, mission1.links.missionPatch], "Expected second image URL requests once second view also becomes visible")
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LaunchesViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = LaunchesViewController(companyInfoLoader: loader, launchLoader: loader, imageLoader: loader)

        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, loader)
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

    private func makeMission(name: String, rocketName: String, url: URL = URL(string: "http://a-url.com")!) -> Launch {
        let rocket = Rocket(name: rocketName, type: "type-\(rocketName)")
        return Launch(missionName: name, launchDate: "2021/20/09", launchSuccess: true, rocket: rocket, links: Link(missionPatch: url))
    }

    class LoaderSpy: LaunchLoader, CompanyInfoLoader, LaunchImageDataLoader {
        // MARK: - LaunchLoader

        private var launchRequests = [(LaunchLoader.Result) -> Void]()

        var loadLaunchCallCount: Int {
            launchRequests.count
        }

        func load(completion: @escaping (LaunchLoader.Result) -> Void) {
            launchRequests.append(completion)
        }

        func completeLaunchLoading(with launch: [Launch] = [], at index: Int = 0) {
            launchRequests[index](.success(launch))
        }

        // MARK: - CompanyInfoLoader

        private var companyInfoRequests = [(CompanyInfoLoader.Result) -> Void]()

        var loadCompanyInfoCallCount: Int {
            companyInfoRequests.count
        }

        func load(completion: @escaping (CompanyInfoLoader.Result) -> Void) {
            companyInfoRequests.append(completion)
        }

        // MARK: - LaunchImageDataLoader

        private(set) var loadedImageURLs = [URL]()

        func loadImageData(from url: URL) {
            loadedImageURLs.append(url)
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

    func simulateLaunchImageViewVisible(at index: Int) {
        _ = launchImageView(at: index)
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
