//
//  CompanyInfoLoader.swift
//  SpaceX
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import Foundation

enum LoadCompanyResult {
    case success(CompanyInfo)
    case error(Error)
}

protocol CompanyInfoLoader {
    func load(completion: @escaping (LoadCompanyResult) -> Void)
}
