//
//  LaunchUIComposer.swift
//  SpaceXiOS
//
//  Created by Avelino Rodrigues on 20/09/2021.
//

import SpaceX
import UIKit

public final class LaunchUIComposer {
    private init() {}

    public static func launchComposedWith(companyInfoLoader: CompanyInfoLoader, launchLoader: LaunchLoader, imageLoader: LaunchImageDataLoader) -> LaunchesViewController {
        let bundle = Bundle(for: LaunchesViewController.self)
        let storyboard = UIStoryboard(name: "Launch", bundle: bundle)
        let launchController = storyboard.instantiateInitialViewController() as! LaunchesViewController

        launchController.title = NSLocalizedString("LAUNCH_VIEW_TITLE", tableName: "Launch", bundle: Bundle(for: LaunchesViewController.self), comment: "Title for the launch view")
        launchController.companyInfoLoader = companyInfoLoader
        launchController.launchLoader = launchLoader
        launchController.imageLoader = imageLoader

        return launchController
    }
}
