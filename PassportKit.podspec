Pod::Spec.new do |spec|

  spec.name         = "PassportKit"
  spec.version      = "0.1"
  spec.summary      = "Swift library used for quick and easy authentication using Laravel passport."
  spec.homepage     = "https://github.com/appoly/PassportKit"
  spec.license      = "MIT"
  spec.platform     = :ios, "11.4"
  spec.ios.deployment_target = "11.4"
  spec.framework = "UIKit"
  spec.dependency 'Valet', '~> 3.2.0'
  spec.dependency 'Alamofire', '~> 4.9.0'
  spec.swift_version = "5.0"

end
