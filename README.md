# PassportKit
 Swift library used for quick and easy oauth authentication.
 
**Installing with Cocoapods**
```
pod 'PassportKit'
```


**Installing with Swift Package Manager**
 - Navigate to `File->Swift Packages->Add Package Dependency`
 - Select your target, then search PassportKit.
 - Set the version to 1.5 (if it isn't already)
 - Click next to install

**Quick start**

First start by creating a PassportConfiguration, this will give the request all the parameters it needs outside of the email and password. 
```
func setupPassport() {
    guard let baseURL = URL(string: "https://google.com") else { return nil }
    let configuration = PassportConfiguration(baseURL: baseURL, mode: .standard(clientID: "1", clientSecret: "awdoncoin12onaoinaoinda9"), keychainID: "PassportTest")
    PassportKit.shared.setup(configuration)
}
```

Then you will need to setup a view model to pass to the authentication function, this view model consists of an email and a password. The values can be set using a string or a textfield as an argument.
```
func setupViewModel() -> PassportViewModel {
    let model = PassportViewModel(delegate: self)
    model.setEmail(string: "test@test.com")
    model.setPassword(string: "secret123")
    
    return model
}
```

Once you have your PassportViewModel you can call the authentication method, passing the model as an argument. This will send a network request that will return an error via a completion handler if it has failed.

```
PassportKit.shared.authenticate(model) { error in
    if let error = error {
        print(error.localizedDescription)
    } else {
        guard let token = passport?.authToken else { return }
        print("Token: \(token)")
    }
}
```

As you can see in the success function above, PassportKit comes with an PassportKitAuthenticationManager class which uses keychain to store your authentication token securely using the keychain ID you set at the beginning in the PassportConfiguration.

**Laravel Sanctum Support**

PassportKit now supports Laravel Sanctum, use passport kit exactly the same, but when setting up, use the sanctum mode (this will no longer require a client id or secret).
```
func setupPassport() {
    guard let baseURL = URL(string: "https://google.com") else { return nil }
    let configuration = PassportConfiguration(baseURL: baseURL, mode: .sanctume, keychainID: "PassportTest")
    PassportKit.shared.setup(configuration)
}
```

Note that the refresh function and the refresh token found in the `AuthenticationManager` class are no longer available when using PassportKit in sactum mode.
