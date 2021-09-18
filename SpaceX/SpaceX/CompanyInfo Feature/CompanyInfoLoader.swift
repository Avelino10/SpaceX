//
//  CompanyInfoLoader.swift
//  SpaceX
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import Foundation

public protocol CompanyInfoLoader {
    typealias Result = Swift.Result<CompanyInfo, Error>

    func load(completion: @escaping (Result) -> Void)
}
