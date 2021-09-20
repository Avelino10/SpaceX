//
//  LaunchesViewControllerTests+Localization.swift
//  SpaceXiOSTests
//
//  Created by Avelino Rodrigues on 20/09/2021.
//

import SpaceXiOS
import XCTest

extension LaunchesViewControllerTests {
    func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Launch"
        let bundle = Bundle(for: LaunchesViewController.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)

        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }

        return value
    }
}
