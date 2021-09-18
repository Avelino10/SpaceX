//
//  CompanyInfoLoader.swift
//  SpaceX
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import Foundation

public enum LoadCompanyResult {
    case success(CompanyInfo)
    case failure(Error)
}

public protocol CompanyInfoLoader {
    func load(completion: @escaping (LoadCompanyResult) -> Void)
}
