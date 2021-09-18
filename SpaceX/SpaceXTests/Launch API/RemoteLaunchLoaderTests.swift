//
//  RemoteLaunchLoaderTests.swift
//  SpaceXTests
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import SpaceX
import XCTest

class RemoteLaunchLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "an error", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                client.complete(withStatusCode: code, data: Data(), at: index)
            })
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = Data("invalidJSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    func test_load_deliversLaunchOn200HTTPResponseWithValidJSON() {
        let (sut, client) = makeSUT()

        let launch1 = makeLaunch(name: "Missin1", rocketName: "Rocket1")

        let launch2 = makeLaunch(name: "Missin2", rocketName: "Rocket2")

        let launches = [launch1.model, launch2.model]

        expect(sut, toCompleteWith: .success(launches), when: {
            let json = makeLaunchesJSON([launch1.json, launch2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }

    func test_load_deliversNoLaunchesOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = makeLaunchesJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteLaunchLoader? = RemoteLaunchLoader(url: url, client: client)

        var capturedResults = [RemoteLaunchLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        let invalidJSON = Data("invalidJSON".utf8)
        client.complete(withStatusCode: 200, data: invalidJSON)

        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteLaunchLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLaunchLoader(url: url, client: client)

        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, client)
    }

    private func makeLaunch(name: String, rocketName: String) -> (model: Launch, json: [String: Any]) {
        let launch1 = Launch(missionName: name, launchDate: "2006-03-24T22:30:00.000Z", launchSuccess: false, rocket: Rocket(name: rocketName, type: "x"), links: Link(missionPatch: URL(string: "http://a-url.com")!))

        let launch1JSON = [
            "mission_name": launch1.missionName,
            "launch_date_utc": launch1.launchDate,
            "launch_success": launch1.launchSuccess,
            "rocket": [
                "rocket_name": launch1.rocket.name,
                "rocket_type": launch1.rocket.type,
            ],
            "links": [
                "mission_patch": launch1.links.missionPatch.absoluteString,
            ],
        ] as [String: Any]

        return (launch1, launch1JSON)
    }

    private func makeLaunchesJSON(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }

    private func failure(_ error: RemoteLaunchLoader.Error) -> RemoteLaunchLoader.Result {
        .failure(error)
    }

    private func expect(_ sut: RemoteLaunchLoader, toCompleteWith expectedResult: RemoteLaunchLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
                case let (.success(receivedInfo), .success(expectedInfo)):
                    XCTAssertEqual(receivedInfo, expectedInfo, file: file, line: line)
                case let (.failure(receivedError as RemoteLaunchLoader.Error), .failure(expectedError as RemoteLaunchLoader.Error)):
                    XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                default:
                    XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 1.0)
    }
}
