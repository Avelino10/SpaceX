//
//  LaunchCell.swift
//  SpaceXiOS
//
//  Created by Avelino Rodrigues on 20/09/2021.
//

import UIKit

public final class LaunchCell: UITableViewCell {
    // Titles
    @IBOutlet var missionTitle: UILabel!
    @IBOutlet var missionDateTimeTitle: UILabel!
    @IBOutlet var missionRocketTitle: UILabel!
    @IBOutlet var missionDifferenceDaysTitle: UILabel!

    // Values
    @IBOutlet public var missionName: UILabel!
    @IBOutlet public var missionDate: UILabel!
    @IBOutlet public var rocketInfo: UILabel!
    @IBOutlet public var missionDays: UILabel!
    @IBOutlet public var missionImage: UIImageView!
    @IBOutlet public var launchStatus: UIImageView!

    override public func awakeFromNib() {
        super.awakeFromNib()

        let bundle = Bundle(for: LaunchCell.self)

        missionTitle.text = NSLocalizedString("LAUNCH_LAUNCHES_MISSION_TITLE", tableName: "Launch", bundle: bundle, comment: "")
        missionDateTimeTitle.text = NSLocalizedString("LAUNCH_LAUNCHES_DATE_TITLE", tableName: "Launch", bundle: bundle, comment: "")
        missionRocketTitle.text = NSLocalizedString("LAUNCH_LAUNCHES_ROCKET_INFO_TITLE", tableName: "Launch", bundle: bundle, comment: "")
    }
}
