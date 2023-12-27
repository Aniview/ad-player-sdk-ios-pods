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
    static let publisherId = "609a943be65f6b2a0c3ffbe5" // replace with yor data
    static let tagId = "63fc78e436e14ce9ad0f5a66" // replace with yor data
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
