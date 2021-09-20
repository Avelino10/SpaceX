//
//  LaunchImageCellController.swift
//  SpaceXiOS
//
//  Created by Avelino Rodrigues on 20/09/2021.
//

import SpaceX
import UIKit

final class LaunchImageCellController {
    private var task: LaunchImageDataLoaderTask?
    private let model: Launch
    private let imageLoader: LaunchImageDataLoader

    init(model: Launch, imageLoader: LaunchImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }

    func view() -> UITableViewCell {
        let cell = LaunchCell()
        cell.missionName.text = model.missionName
        cell.missionDate.text = model.launchDate
        cell.rocketInfo.text = "\(model.rocket.name)/\(model.rocket.type)"
        cell.missionImage.image = nil
        task = imageLoader.loadImageData(from: model.links.missionPatch) { [weak cell] result in
            let data = try? result.get()
            let image = data.map(UIImage.init) ?? nil
            cell?.missionImage.image = image
        }

        return cell
    }

    deinit {
        task?.cancel()
    }
}
