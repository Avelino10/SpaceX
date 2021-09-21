//
//  SceneDelegate.swift
//  SpaceXApp
//
//  Created by Avelino Rodrigues on 20/09/2021.
//

import SpaceX
import SpaceXiOS
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }

        let companyInfoURL = URL(string: "https://api.spacexdata.com/v3/info")!
        let launchesURL = URL(string: "https://api.spacexdata.com/v3/launches")!

        let remoteClient = URLSessionHTTPClient(session: .shared)
        let companyLoader = RemoteCompanyInfoLoader(url: companyInfoURL, client: remoteClient)
        let launchesLoader = RemoteLaunchLoader(url: launchesURL, client: remoteClient)
        let imageLoader = RemoteLaunchImageDataLoader(client: remoteClient)

        let launchesViewController = LaunchUIComposer.launchComposedWith(companyInfoLoader: companyLoader, launchLoader: launchesLoader, imageLoader: imageLoader)

        window?.rootViewController = launchesViewController
    }
}
