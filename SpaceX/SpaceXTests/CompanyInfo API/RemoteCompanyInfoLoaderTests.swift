//
//  RemoteCompanyInfoLoaderTests.swift
//  SpaceXTests
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import SpaceX
import XCTest

class RemoteCompanyInfoLoaderTests: XCTestCase {
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

    func test_load_deliversCompanyInfoOn200HTTPResponseWithValidJSON() {
        let (sut, client) = makeSUT()

        let companyInfo = CompanyInfo(companyName: "company", founderName: "founder", year: 2021, employees: 0, launchSites: 0, valuation: 0)

        let companyInfoJSON = [
            "name": companyInfo.companyName,
            "founder": companyInfo.founderName,
            "founded": companyInfo.year,
            "employees": companyInfo.employees,
            "launch_sites": companyInfo.launchSites,
            "valuation": companyInfo.valuation,
        ] as [String: Any]

        expect(sut, toCompleteWith: .success(companyInfo), when: {
            let json = try! JSONSerialization.data(withJSONObject: companyInfoJSON)
            client.complete(withStatusCode: 200, data: json)
        })
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteCompanyInfoLoader? = RemoteCompanyInfoLoader(url: url, client: client)

        var capturedResults = [RemoteCompanyInfoLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        let invalidJSON = Data("invalidJSON".utf8)
        client.complete(withStatusCode: 200, data: invalidJSON)

        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteCompanyInfoLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCompanyInfoLoader(url: url, client: client)

        trackMemoryLeaks(client, file: file, line: line)
        trackMemoryLeaks(sut, file: file, line: line)

        return (sut, client)
    }

    private func failure(_ error: RemoteCompanyInfoLoader.Error) -> RemoteCompanyInfoLoader.Result {
        .failure(error)
    }

    private func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }

    private func expect(_ sut: RemoteCompanyInfoLoader, toCompleteWith expectedResult: RemoteCompanyInfoLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
                case let (.success(receivedInfo), .success(expectedInfo)):
                    XCTAssertEqual(receivedInfo, expectedInfo, file: file, line: line)
                case let (.failure(receivedError as RemoteCompanyInfoLoader.Error), .failure(expectedError as RemoteCompanyInfoLoader.Error)):
                    XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                default:
                    XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 1.0)
    }

    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }

        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }

        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }

        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: messages[index].url,
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!

            messages[index].completion(.success(data, response))
        }
    }
}
