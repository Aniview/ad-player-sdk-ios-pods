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
    static let publisherId = "63d8ff1bad47af25a704c884" // replace with yor data
    static let tagId = "64d23f8ebcce13e871070576" // replace with yor data
    static let storeURL = "https://apps.apple.com/us/app/adplayer-sample/id1234567" // replace with yor data
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { // swiftlint:disable:this line_length

        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = LandingVC(
            publisherId: Constants.publisherId,
            tagId: Constants.tagId
        )
        window.rootViewController = UINavigationController(rootViewController: viewController)
        window.makeKeyAndVisible()
        self.window = window

        AdPlayer.initSdk(storeURL: URL(string: Constants.storeURL)!)

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                print("Tracking: authorized:", status == .authorized)
            }
        }
    }
}
