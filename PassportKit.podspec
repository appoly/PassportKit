Pod::Spec.new do |spec|

  spec.name         = "PassportKit"
  spec.version      = "0.9.6"
  spec.summary      = "Swift library used for quick and easy oauth authentication."
  spec.homepage     = "https://github.com/appoly/PassportKit"
  spec.license      = "MIT"
  spec.platform     = :ios, "11.4"
  spec.ios.deployment_target = "11.4"
  spec.framework = "UIKit"
  spec.dependency 'Valet', '~> 3.2.0'
  spec.dependency 'Alamofire', '~> 4.9.0'
  spec.swift_version = "5.0"
  spec.authors = "James Wolfe"
  spec.source_files = 'PassportKit/Source/*'
  spec.source = { :git => 'https://github.com/appoly/PassportKit.git', :tag => spec.version }

end