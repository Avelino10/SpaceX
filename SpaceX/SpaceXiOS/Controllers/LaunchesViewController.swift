//
//  LaunchesViewController.swift
//  SpaceXiOS
//
//  Created by Avelino Rodrigues on 20/09/2021.
//

import SpaceX
import UIKit

public final class LaunchesViewController: UITableViewController {
    var companyInfoLoader: CompanyInfoLoader?
    var launchLoader: LaunchLoader?
    var imageLoader: LaunchImageDataLoader?
    private var tableModel = [Launch]()
    private var cellControllers = [IndexPath: LaunchImageCellController]()
    @IBOutlet var headerCompany: UILabel!
    @IBOutlet public var headerCompanyDescription: UILabel!
    @IBOutlet var headerLaunches: UILabel!

    override public func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: LaunchesViewController.self)

        companyInfoLoader?.load { [weak self] result in
            if let info = try? result.get() {
                if Thread.isMainThread {
                    self?.updateDescription(info: info)
                } else {
                    DispatchQueue.main.async {
                        self?.updateDescription(info: info)
                    }
                }
            }
        }

        launchLoader?.load { [weak self] result in
            if let launches = try? result.get() {
                self?.tableModel = launches
                if Thread.isMainThread {
                    self?.tableView.reloadData()
                } else {
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }

        headerCompany.text = NSLocalizedString("LAUNCH_HEADER_TITLE", tableName: "Launch", bundle: bundle, comment: "")
        headerLaunches.text = NSLocalizedString("LAUNCH_LAUNCHES_TITLE", tableName: "Launch", bundle: bundle, comment: "")
    }

    private func updateDescription(info: CompanyInfo) {
        let bundle = Bundle(for: LaunchesViewController.self)
        let string = NSLocalizedString("LAUNCH_HEADER_DESCRIPTION", tableName: "Launch", bundle: bundle, comment: "")
        headerCompanyDescription.text = String(format: string, info.companyName, info.founderName, info.year, info.employees, info.launchSites, info.valuation)
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }

    override public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        removeCellController(forRowAt: indexPath)
    }

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).select { vc in
            present(vc, animated: true)
        }
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
