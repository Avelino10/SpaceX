//
//  LaunchesViewController.swift
//  SpaceXiOS
//
//  Created by Avelino Rodrigues on 20/09/2021.
//

import SpaceX
import UIKit

public protocol LaunchImageDataLoaderTask {
    func cancel()
}

public protocol LaunchImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> LaunchImageDataLoaderTask
}

public final class LaunchesViewController: UITableViewController {
    private var companyInfoLoader: CompanyInfoLoader?
    private var launchLoader: LaunchLoader?
    private var imageLoader: LaunchImageDataLoader?
    private var tableModel = [Launch]()
    private var tasks = [IndexPath: LaunchImageDataLoaderTask]()

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
        cell.missionImage.image = nil
        tasks[indexPath] = imageLoader?.loadImageData(from: cellModel.links.missionPatch) { [weak cell] result in
            let data = try? result.get()
            if let image = data.map(UIImage.init) {
                cell?.missionImage.image = image
            }
        }

        return cell
    }

    override public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tasks[indexPath]?.cancel()
        tasks[indexPath] = nil
    }
}
