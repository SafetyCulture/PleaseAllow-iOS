# PleaseAllow

## Usage

#### Location
```swift
PleaseAllow.location.always { result, error in
    switch result {
        case .allowed     : print("Authorized")
        case .softDenial  : print("Denied Soft")
        case .hardDenial  : print("Denied Hard")
        case .restricted  : print("Restricted")
        case .unavailable : print("Unavailable")
    }
}
```

#### Camera
```swift
PleaseAllow.camera { whatBabySaid, error in
    DispatchQueue.main.async {
        switch whatBabySaid {
            case .allowed     : print("Authorized")
            case .softDenial  : print("Denied Soft")
            case .hardDenial  : print("Denied Hard")
            case .restricted  : print("Restricted")
            case .unavailable : print("Unavailable")
        }
    }
}
```

## Presenting a Soft Ask

Display a Soft Ask before presenitng the default alert for a permission.
Soft Ask can be presented either as a Modal or Full Screen. See example below.


```swift
PleaseAllow.Managers.contacts.softAskView = {
    let view = SoftAskView(.fullScreen)
    view.allowButtonTitle = "Allow"
    view.denyButtonTitle = "Don't Allow"
    view.title = "Allow Contacts"
    view.description = "Please allow access to your contacts to invite people."
    return view
}()

PleaseAllow.contacts { result, error in
    switch result {
        case .allowed     : print("Authorized")
        case .softDenial  : print("Denied Soft")
        case .hardDenial  : print("Denied Hard")
        case .restricted  : print("Restricted")
        case .unavailable : print("Unavailable")
    }
}
```

![alt text](/Screenshots/Modal.png "")
![alt text](/Screenshots/FullScreen.png "")

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
```

#### Provide an instance of the tracker to the permission request
```swift
PleaseAllow.photoLibrary(tracker: PermissionTracker()) { result, error in
    switch result {
        case .allowed     : print("Authorized")
        case .softDenial  : print("Denied Soft")
        case .hardDenial  : print("Denied Hard")
        case .restricted  : print("Restricted")
        case .unavailable : print("Unavailable")
    }
}
```
