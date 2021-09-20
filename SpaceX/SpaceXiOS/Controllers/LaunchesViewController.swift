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
    private var imageLoader: LaunchImageDataLoader?
    private var tableModel = [Launch]()
    private var cellControllers = [IndexPath: LaunchImageCellController]()

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
        return cellController(forRowAt: indexPath).view()
    }

    override public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        removeCellController(forRowAt: indexPath)
    }

    private func cellController(forRowAt indexPath: IndexPath) -> LaunchImageCellController {
        let cellModel = tableModel[indexPath.row]
        let cellController = LaunchImageCellController(model: cellModel, imageLoader: imageLoader!)
        cellControllers[indexPath] = cellController

        return cellController
    }

    private func removeCellController(forRowAt indexPath: IndexPath) {
        cellControllers[indexPath] = nil
    }
}
