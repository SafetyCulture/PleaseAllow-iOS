# PleaseAllow

## Usage

#### Location
```swift
PleaseAllow.location.always { result, eror in
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
PleaseAllow.camera { whatBabySaid, eror in
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

#### Asking Politely
```swift
BabyPlease.Managers.contacts.softAskView = {
    let view = SoftAskView()
    view.cornerRadius = 20
    view.allowButtonTitle = "Allow"
    view.denyButtonTitle = "Don't Allow"
    view.title = "Allow Contacts"
    view.description = "Please allow access to your contacts to invite people."
    return view
}()

PleaseAllow.contacts { result, eror in
    switch result {
        case .allowed     : print("Authorized")
        case .softDenial  : print("Denied Soft")
        case .hardDenial  : print("Denied Hard")
        case .restricted  : print("Restricted")
        case .unavailable : print("Unavailable")
    }
}
```
