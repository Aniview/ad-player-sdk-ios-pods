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

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|

      if target.name == 'RxSwift'
        # fixes: "Undefined symbols", "Symbol not found" errors for RxSwift
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
    end
  end
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

        AdPlayer.initSdk()

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
```

YourViewController.swift
```java
import SpotImStandaloneAds

class YourViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
[https://github.com/Aniview/spotim-sdk-ios-pods/tree/main/SpotImAdsSample](https://github.com/Aniview/ad-player-sdk-ios-pods/tree/main/ADPlayerBasicSample)

## Author

https://aniview.com/

## License

All rights reserved to ANIVIEW LTD 2023

