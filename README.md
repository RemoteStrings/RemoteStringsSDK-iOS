# RemoteStringsSDK

This package allows you to easily integrate the [RemoteStrings](https://www.remotestrings.app) service into your iOS applications. It enables you to instantly update your remote string files and deliver them to users without re-publishing your app.

## Minimum Requirements

- iOS 13.0+
- Swift 5.3+
- Xcode 12.0+

## Features

-   Update strings instantly and remotely.
-   Automatically downloads the latest strings when the app starts.
-   Integrates automatically with your existing `NSLocalizedString` usage (via Method Swizzling).
-   Uses the last cached version when there is no internet connection.
-   Easy setup with Swift Package Manager (SPM).

## Installation

### Swift Package Manager

Follow these steps to add `RemoteStringsSDK` to your Xcode project:

1.  In Xcode, go to **File > Add Packages...**.
2.  In the window that opens, paste this repository's URL into the search box in the upper right corner:
    ```
    https://github.com/RemoteStrings/RemoteStringsSDK-iOS
    ```
3.  For **Dependency Rule**, select **Up to Next Major Version** and choose `1.0.0` as the version.
4.  Click **Add Package** and wait for the package to be added to your project.

## Integration and Usage

Integrating the SDK into your project is very straightforward. You will typically perform these steps inside your `AppDelegate` or `SceneDelegate`.

### 1. Initialize the SDK

You need to initialize the SDK at the beginning of your application's lifecycle, for example, in the `application(_:didFinishLaunchingWithOptions:)` method of your `AppDelegate`. This is done with the `platformToken` you can find on your RemoteStrings dashboard.

```swift
import UIKit
import RemoteStringsSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize RemoteStringsSDK with your platform token.
        // This process starts downloading the latest strings in the background.
        RemoteStringsSDK.initialize(platformToken: "YOUR_PLATFORM_TOKEN")
        
        return true
    }
    
    // ...
}
```

### 2. Automatic String Replacement (Method Swizzling)

If you use standard constructs like `NSLocalizedString` or `Text("key")` (SwiftUI) in your project, you can have the SDK automatically intercept these calls and replace them with the remote strings.

To do this, you just need to call the `startSwizzling()` method after the `initialize` method.

```swift
import UIKit
import RemoteStringsSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        RemoteStringsSDK.initialize(platformToken: "YOUR_PLATFORM_TOKEN")
        
        // Start swizzling for automatic string replacement.
        // Make sure this method is called before the UI is rendered.
        RemoteStringsSDK.startSwizzling()
        
        return true
    }

    // ...
}
```

After this step, existing calls in your code like `NSLocalizedString("welcome_message", comment: "")` will be automatically replaced with the value from the RemoteStrings server if the "welcome_message" key exists there.

### 3. Manually Fetching Strings

If you don't want to use automatic replacement or if you want to get a specific string directly from the SDK, you can use the `string(_:)` method.

```swift
import RemoteStringsSDK

// Get a string by its key (returns key if not found)
let title = RemoteStringsSDK.string("main_screen_title")

// Specify a default value to use if the key is not found
let buttonText = RemoteStringsSDK.string("submit_button", default: "Submit")

// With format arguments
let greeting = RemoteStringsSDK.string("hello_user", arguments: [username])

// With arguments and custom default
let message = RemoteStringsSDK.string("welcome", arguments: [name, age], default: "Welcome %@, you are %d years old")
```

### 4. Handling Updates and Failures

The SDK posts notifications to `NotificationCenter` when strings are successfully updated or when an update fails. You can observe these notifications to update your UI or handle errors.

```swift
import RemoteStringsSDK

// Observe for successful updates
NotificationCenter.default.addObserver(
    forName: RemoteStringsSDK.didUpdateNotification,
    object: nil,
    queue: .main
) { _ in
    // Strings have been updated. You can reload your UI here.
    print("Remote strings updated!")
}

// Observe for update failures
NotificationCenter.default.addObserver(
    forName: RemoteStringsSDK.didFailUpdateNotification,
    object: nil,
    queue: .main
) { _ in
    // The update process failed (network error, invalid bundle, etc.)
    // You might want to log this or retry later if needed.
    print("Failed to update remote strings.")
}
```

That's it! You are now ready to manage your app's strings remotely.

## License

This SDK is distributed as a proprietary binary framework. See [LICENSE](LICENSE) for details.

The Software is provided for use with RemoteStrings service only and requires an active RemoteStrings account.
