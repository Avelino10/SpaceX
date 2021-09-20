//
//  LaunchesViewController.swift
//  SpaceXiOS
//
//  Created by Avelino Rodrigues on 20/09/2021.
//

import SpaceX
import UIKit

public final class LaunchesViewController: UITableViewController {
    private var companyInfoLoader: CompanyInfoLoader?
    private var launchLoader: LaunchLoader?
    public convenience init(companyInfoLoader: CompanyInfoLoader, launchLoader: LaunchLoader) {
        self.init()
        self.companyInfoLoader = companyInfoLoader
        self.launchLoader = launchLoader
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        companyInfoLoader?.load { _ in }
        launchLoader?.load { _ in }
    }
}
