# AdPlayerSDK iOS

## Requirements
 * iOS >= 12.0
 * Request tracking authorization (for iOS >= 14):
   https://developer.apple.com/documentation/apptrackingtransparency
 * request GDPR consent (if needed)

## Installation

SpotImStandaloneAds is available through [CocoaPods](https://cocoapods.org). To install
it, add the following line to your Podfile:

```ruby
target 'YourApp' do
  pod 'AdPlayerSDK'
end
```

## Usage example

AppDelegate.swift
```java
import AdPlayerSDK
import AppTrackingTransparency

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { // swiftlint:disable:this line_length

        createLandingScreen()
        AdPlayer.initSdk(storeURL: URL(string: "https:apps.apple.com/.....")!)

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        /// NOTE: request GDPR consent if needed
        /// https://support.google.com/admanager/answer/7673898?hl=en&ref_topic=10366389&sjid=10800144486024696532-EU

        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                print("Tracking: authorized:", status == .authorized)
            }
        }
    }
}
```

YourViewController.swift
```java
import SpotImStandaloneAds

class YourViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        /// NOTE: request GDPR consent if needed
        /// https://support.google.com/admanager/answer/7673898?hl=en&ref_topic=10366389&sjid=10800144486024696532-EU
    
        let placement = AdPlayerPlacementViewController(tagId: tagId)
        placement.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(placement)
        view.addSubview(placement.view)
        NSLayoutConstraint.activate([
            placement.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placement.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placement.view.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        placement.didMove(toParent: self)
    }
}
```

## Sample project
[ADPlayerBasicSample](https://github.com/Aniview/ad-player-sdk-ios-pods/tree/main/ADPlayerBasicSample)

## Author

https://aniview.com/

## License

All rights reserved to ANIVIEW LTD 2023

