//
//  LaunchesViewController.swift
//  SpaceXiOS
//
//  Created by Avelino Rodrigues on 20/09/2021.
//

import SpaceX
import UIKit

public protocol LaunchImageDataLoader {
    func loadImageData(from url: URL)
}

public final class LaunchesViewController: UITableViewController {
    private var companyInfoLoader: CompanyInfoLoader?
    private var launchLoader: LaunchLoader?
    private var imageLoader: LaunchImageDataLoader?
    private var tableModel = [Launch]()

    public convenience init(companyInfoLoader: CompanyInfoLoader, launchLoader: LaunchLoader, imageLoader: LaunchImageDataLoader) {
        self.init()
        self.companyInfoLoader = companyInfoLoader
        self.launchLoader = launchLoader
        self.imageLoader = imageLoader
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        companyInfoLoader?.load { _ in }
        launchLoader?.load { [weak self] result in
            if let launches = try? result.get() {
                self?.tableModel = launches
                self?.tableView.reloadData()
            }
        }
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = LaunchCell()
        cell.missionName.text = cellModel.missionName
        cell.missionDate.text = cellModel.launchDate
        cell.rocketInfo.text = "\(cellModel.rocket.name)/\(cellModel.rocket.type)"

        imageLoader?.loadImageData(from: cellModel.links.missionPatch)

        return cell
    }
}
