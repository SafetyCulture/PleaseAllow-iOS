> **Warning**
> This repository is no longer maintained and will soon be archived.
>
> After a careful consideration we have made a difficult decision to no longer maintain this project.
> Our efforts are concentrated in different areas of our scaling business and, unfortunately, it meant that we could not provide the love and care that this project deserves.
> We are aiming to archive the project by 31/12/2022.
> Please consider creating a fork if you would like to continue using this project in your codebase.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# PleaseAllow

## Usage

#### Location
```swift
Please.allow.location.always { result, error in
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
Please.allow.camera { result, error in
    switch result {
        case .allowed     : print("Authorized")
        case .softDenial  : print("Denied Soft")
        case .hardDenial  : print("Denied Hard")
        case .restricted  : print("Restricted")
        case .unavailable : print("Unavailable")
    }
}
```

## Presenting a Soft Ask

Display a Soft Ask before presenitng the default alert for a permission.
Soft Ask can be presented either as a Modal or Full Screen. See example below.


```swift
let softAskView: SoftAskView = {
    let view = SoftAskView(.fullScreen)
    view.allowButtonTitle = "Allow"
    view.denyButtonTitle = "Don't Allow"
    view.title = "Allow Contacts"
    view.description = "Please allow access to your contacts to invite people."
    return view
}()

Please.allow.contacts(softAskView: softAskView) { result, error in
    switch result {
        case .allowed     : print("Authorized")
        case .softDenial  : print("Denied Soft")
        case .hardDenial  : print("Denied Hard")
        case .restricted  : print("Restricted")
        case .unavailable : print("Unavailable")
    }
}
```

![alt text](/Screenshots/SoftAskView.png "")


## Presenting a Denied Alert

Display a Denied Alert if the permission has previously been denied. Denied alert can redirect user to App Settings.
`DeniedAlert` is a subclass of `SoftAskView` and can be formatted in the same way. See example below.


```swift
let deniedAlert: DeniedAlert = {
DeniedAlert is a subclass if SoftAskView and can be formatted in the same way.

let deniedAlert = {
    let view = DeniedAlert(.modal)
    view.allowButtonTitle = "Settings"
    view.denyButtonTitle = "Cancel"
    view.title = "Contacts Denied"
    view.description = "Contact Permission has been denied. Please open Settings and allow access to your contacts to invite people."
    return view
}()

Please.allow.contacts(softAskView: softAskView, deniedAlert: deniedAlert) { result, error in
    switch result {
        case .allowed     : print("Authorized")
        case .softDenial  : print("Denied Soft")
        case .hardDenial  : print("Denied Hard")
        case .restricted  : print("Restricted")
        case .unavailable : print("Unavailable")
    }
}
```

![alt text](/Screenshots/DeniedAlert.png "")


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
Please.allow.photoLibrary(softAskView: softAskView, deniedAlert: deniedAlert, tracker: tracker) { result, error in
    switch result {
        case .allowed     : print("Authorized")
        case .softDenial  : print("Denied Soft")
        case .hardDenial  : print("Denied Hard")
        case .restricted  : print("Restricted")
        case .unavailable : print("Unavailable")
    }
}
```

## Supported Permissions
- Camera
- Photo Library
- Contacts
- Push Notifications
- Location
