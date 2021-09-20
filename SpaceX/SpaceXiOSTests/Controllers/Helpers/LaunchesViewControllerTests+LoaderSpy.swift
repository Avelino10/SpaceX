//
//  LaunchesViewControllerTests+LoaderSpy.swift
//  SpaceXiOSTests
//
//  Created by Avelino Rodrigues on 20/09/2021.
//

import Foundation
import SpaceX
import SpaceXiOS

extension LaunchesViewControllerTests {
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

        private struct TaskSpy: LaunchImageDataLoaderTask {
            let cancelCallback: () -> Void
            func cancel() {
                cancelCallback()
            }
        }

        private var imageRequests = [(url: URL, completion: (LaunchImageDataLoader.Result) -> Void)]()

        var loadedImageURLs: [URL] {
            imageRequests.map { $0.url }
        }

        private(set) var cancelledImageURLs = [URL]()

        func loadImageData(from url: URL, completion: @escaping (LaunchImageDataLoader.Result) -> Void) -> LaunchImageDataLoaderTask {
            imageRequests.append((url, completion))

            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }

        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(imageData))
        }
    }
}
