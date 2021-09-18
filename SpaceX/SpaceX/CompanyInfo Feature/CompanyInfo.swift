//
//  CompanyInfo.swift
//  SpaceX
//
//  Created by Avelino Rodrigues on 18/09/2021.
//

import Foundation

public struct CompanyInfo: Equatable {
    public let companyName: String
    public let founderName: String
    public let year: Int
    public let employees: Int
    public let launchSites: Int
    public let valuation: Int

    public init(companyName: String, founderName: String, year: Int, employees: Int, launchSites: Int, valuation: Int) {
        self.companyName = companyName
        self.founderName = founderName
        self.year = year
        self.employees = employees
        self.launchSites = launchSites
        self.valuation = valuation
    }
}
