//
//  SceneDelegate.swift
//  AdPlayerSample
//
//  Created by Pavel Yevtukhov on 23.07.2024.
//

import AdPlayerSDK
import UIKit
import AppTrackingTransparency

private enum Constants {
    static let publisherId = "565c56d3181f46bd608b459a" // replace with yor data
    static let tagId = "646a0773ea9d79fc1d0d45b4" // replace with yor data
    static let storeURL = "https://apps.apple.com/us/app/adplayer-sample/id1234567" // replace with yor data
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let viewController = LandingVC(
            publisherId: Constants.publisherId,
            tagId: Constants.tagId
        )
        window.rootViewController = UINavigationController(rootViewController: viewController)
        window.makeKeyAndVisible()

        AdPlayer.initSdk(storeURL: URL(string: Constants.storeURL)!)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        DispatchQueue.main.async { // ensure the app view is ready
            ATTrackingManager.requestTrackingAuthorization { status in
                print("Tracking: authorized:", status == .authorized)
            }
        }
    }
}
