# PassportKit
 Swift library used for quick and easy oauth authentication.
 
**Installing with Cocoapods**
```
pod 'PassportKit'
```


**Installing with Swift Package Manager**
 - Navigate to `File->Swift Packages->Add Package Dependency`
 - Select your target, then search PassportKit.
 - Set the version to 1.1 (if it isn't already)
 - Click next to install

**Quick start**

First start by creating a PassportConfiguration, this will give the request all the parameters it needs outside of the email and password. 
```
func setupPassport() -> PassportKit? {
    guard let baseURL = URL(string: "https://google.com") else { return nil }
    let configuration = PassportConfiguration(baseURL: baseURL, clientID: "1", clientSecret: "awdoncoin12onaoinaoinda9", keychainID: "PassportTest")
    return PassportKit(configuration, delegate: self)
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

Once you have your PassportKit object and your PassportViewModel you can call the authentication method, passing the model as an argument.

`passport.authenticate(model)`

This will send a network request that will return a success or a fail - these two states are handled by PassportKit's PassportViewDelegate, which is a protocol comprising of two functions:
```
func failed(_ error: String) {
    print(error)
}

func success() {
    guard let token = passport?.getAuthToken() else { return }
    print("Token: \(token)")
}
```

As you can see in the success function above, PassportKit comes with an AuthenticationManager class which uses keychain to store your authentication token securely using the keychain ID you set at the beginning in the PassportConfiguration.
