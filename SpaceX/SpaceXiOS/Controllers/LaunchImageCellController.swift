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
    private var cell: LaunchCell?

    init(model: Launch, imageLoader: LaunchImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }

    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()

        cell?.missionName.text = model.missionName
        cell?.missionDate.text = getDateOfLaunch(from: model.launchDate)
        cell?.rocketInfo.text = String(format: localize(key: "LAUNCH_LAUNCHES_ROCKET_INFO_VALUE"), model.rocket.name, model.rocket.type)
        cell?.launchStatus.image = model.launchSuccess ? UIImage(systemName: "checkmark") : UIImage(systemName: "xmark")

        let daysDifference = getDaysDifference(from: model.launchDate)
        let daysDifferenceTitle = String(format: localize(key: "LAUNCH_LAUNCHES_DATE_DIFFERENCE_TITLE"), daysDifference < 0 ? "since" : "from")
        cell?.missionDifferenceDaysTitle.text = daysDifferenceTitle
        cell?.missionDays.text = "\(abs(daysDifference))"

        cell?.missionImage.image = nil
        task = imageLoader.loadImageData(from: model.links.missionPatch) { [weak cell] result in
            let data = try? result.get()
            let image = data.map(UIImage.init) ?? nil
            if Thread.isMainThread {
                cell?.missionImage.image = image
            } else {
                DispatchQueue.main.async {
                    cell?.missionImage.image = image
                }
            }
        }

        return cell!
    }

    deinit {
        cell = nil
        task?.cancel()
    }

    private func localize(key: String) -> String {
        NSLocalizedString(key, tableName: "Launch", bundle: Bundle(for: LaunchImageCellController.self), comment: "")
    }

    private func getDateOfLaunch(from launchDate: String) -> String {
        let dateFormatter = getDateFormat()
        let date = dateFormatter.date(from: launchDate) ?? Date()

        let printDateFormatter = DateFormatter()
        printDateFormatter.dateFormat = "yyyy-MM-dd"

        let printTimeFormatter = DateFormatter()
        printTimeFormatter.dateFormat = "HH:mm"

        return String(format: localize(key: "LAUNCH_LAUNCHES_DATE_VALUE"), printDateFormatter.string(from: date), printTimeFormatter.string(from: date))
    }

    private func getDaysDifference(from launchDate: String) -> Int {
        let dateFormatter = getDateFormat()
        let date = dateFormatter.date(from: launchDate) ?? Date()

        let calendar = Calendar.current
        let dateNow = calendar.startOfDay(for: Date())
        let dateLaunchDate = calendar.startOfDay(for: date)

        let components = calendar.dateComponents([.day], from: dateNow, to: dateLaunchDate)

        return components.day ?? 0
    }

    private func getDateFormat() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        return dateFormatter
    }
}
