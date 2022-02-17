// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription


let package = Package(
    name: "PassportKit",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "PassportKit",
            targets: ["PassportKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/square/Valet.git", from: "3.2.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "PassportKit",
            dependencies: [
                Target.Dependency(stringLiteral: "Valet")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "PassportKitTests",
            dependencies: ["PassportKit"]),
    ]
)
