Pod::Spec.new do |spec|

  spec.name         = "PassportKit"
  spec.version      = "1.6.5"
  spec.license      = "MIT"
  spec.summary      = "Swift library used for quick and easy oauth authentication."
  spec.homepage     = "https://github.com/appoly/PassportKit"
  spec.authors = "James Wolfe"
  spec.source = { :git => 'https://github.com/appoly/PassportKit.git', :tag => spec.version }

  spec.ios.deployment_target = "12.1"
  spec.framework = "UIKit"
  spec.dependency 'Valet', '~> 3.2.0'
  spec.dependency 'Alamofire', '~> 5.4.1'

  spec.swift_versions = ["5.0", "5.1"]
  
  spec.source_files = "Sources/**/*.swift", "Sources/*/*.swift"
  

end
