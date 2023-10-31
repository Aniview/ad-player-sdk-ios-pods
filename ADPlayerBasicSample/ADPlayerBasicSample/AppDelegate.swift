//
//  AppDelegate.swift
//  ADPlayerBasicSample
//
//  Created by Pavel Yevtukhov on 04.08.2023.
//

import AppTrackingTransparency
import AdPlayerSDK
import UIKit

private enum Constants {
    static let publisherId = "" // replace with yor data
    static let tagId = "" // replace with yor data
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { // swiftlint:disable:this line_length

        createLandingScreen()

        AdPlayer.initSdk()

        return true
    }

    private func createLandingScreen() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = LandingVC(
            publisherId: Constants.publisherId,
            tagId: Constants.tagId
        )
        window.rootViewController = UINavigationController(rootViewController: viewController)
        window.makeKeyAndVisible()
        self.window = window
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                print("Tracking: authorized:", status == .authorized)
            }
        }
    }
}
