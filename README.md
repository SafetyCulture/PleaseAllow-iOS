<p align="left">
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
</p>

# PleaseAllow

## Usage

```swift
extension Please.Location {
    static let sitePicker = Self.init(
        requestType: .whenInUse,
        softAsk: .init(
            title: "Allow Location Access",
            description: "Allow location access to select a site",
            image: sitePickerImage,
            allowButton: .init(title: "Allow"),
            denyButton: .init(title: "Don't Allow")
        ),
        deniedAlert: .init(
            title: "Allow Location Access",
            description: "Location access has been denied. Please open settings and turn on Location.",
            image: sitePickerImage,
            allowButton: .init(title: "Settings"),
            denyButton: .init(title: "Cancel")
        )
    )
}

Please.allow(.location(.sitePicker)) { result in
    if result == .authorized {
        self.presentSitePicker()
    }
}
```

![alt text](/Screenshots/SoftAskView.png "")



## Tracking

Every action in the framework can be tracked by conforming to protocol `PleaseAllowTracker`. See example below.

#### Create a tracking class
```swift
class PermissionTracker: PleaseAllowTracker {
    func track(_ action: PleaseAllow.Action) {
        print(action.stringValue)
        // Insert tracking code here
    }
}

let tracker = PermissionTracker()
```

#### Provide an instance of the tracker to the permission request
```swift
Please.allow(.location(.sitePicker), eventListener: tracker) { result in
    handle(result)
}
```

## Supported Permissions
- Camera
- Photo Library
- Contacts
- Location
- Push Notifications
