Pod::Spec.new do |spec|

  spec.name         = "PassportKit"
  spec.version      = "0.9.8"
  spec.license      = "MIT"
  spec.summary      = "Swift library used for quick and easy oauth authentication."
  spec.homepage     = "https://github.com/appoly/PassportKit"
  spec.authors = "James Wolfe"
  spec.source = { :git => 'https://github.com/appoly/PassportKit.git', :tag => spec.version }

  spec.ios.deployment_target = "11.4"
  spec.framework = "UIKit"
  spec.dependency 'Valet', '~> 3.2.0'
  spec.dependency 'Alamofire', '~> 4.9.0'

  spec.swift_versions = ["5.0", "5.1]"
  
  spec.source_files = "PassportKit/Source/*.swift"
  

end