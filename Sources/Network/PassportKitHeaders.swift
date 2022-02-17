//
//  PassportKitHeaders.swift
//  
//
//  Created by James Wolfe on 20/12/2021.
//



import Foundation



fileprivate extension Bundle {
    
    var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
    
    var appName: String? {
        return self.infoDictionary!["CFBundleName"] as? String
    }

}


typealias HTTPHeader = (name: String, value: String)
class PassportKitHeaders {
    
    private static var userAgent: HTTPHeader = {
        let bundle = Bundle.main
        let info = bundle.infoDictionary
        let executable = (info?[kCFBundleExecutableKey as String] as? String) ??
            (ProcessInfo.processInfo.arguments.first?.split(separator: "/").last.map(String.init)) ??
            "Unknown"
        let bundleIdentifier = bundle.bundleIdentifier ?? "Unknown"
        let appVersion = bundle.releaseVersionNumber ?? "Unknown"
        let appBuild = bundle.buildVersionNumber ?? "Unknown"

        let osNameVersion: String = {
            let version = ProcessInfo.processInfo.operatingSystemVersion
            let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
            let osName: String = {
                #if os(iOS)
                #if targetEnvironment(macCatalyst)
                return "macOS(Catalyst)"
                #else
                return "iOS"
                #endif
                #elseif os(watchOS)
                return "watchOS"
                #elseif os(tvOS)
                return "tvOS"
                #elseif os(macOS)
                return "macOS"
                #elseif os(Linux)
                return "Linux"
                #elseif os(Windows)
                return "Windows"
                #else
                return "Unknown"
                #endif
            }()

            return "\(osName) \(versionString)"
        }()

        let passportKitVersion = "PassportKit/1.6.6"
        return HTTPHeader(name: "User-Agent", value:"\(executable)/\(appVersion) (\(bundleIdentifier); build:\(appBuild); \(osNameVersion)) \(passportKitVersion)")
    }()
    
    private static var acceptEncoding: HTTPHeader = {
        return HTTPHeader(name: "Accept-Encoding", value:"br;q=1.0, gzip;q=0.9, deflate;q=0.8")
    }()
    
    private static var contentType: HTTPHeader = {
        return HTTPHeader(name: "Content-Type", value:"application/x-www-form-urlencoded")
    }()
    
    private static var accept: HTTPHeader = {
        return HTTPHeader(name: "Accept", value:"application/json")
    }()
    
    private static var acceptLanguage: HTTPHeader = {
        return HTTPHeader(name: "Accept-Language", value: "en;q=1.0")
    }()
    
    public static var defaultHeaders: [HTTPHeader] = {
        return [acceptLanguage, accept, contentType, acceptEncoding, userAgent]
    }()
    
}
