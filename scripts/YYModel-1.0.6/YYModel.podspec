Pod::Spec.new do |s|
  s.name = "YYModel"
  s.version = "1.0.6"
  s.summary = "High performance model framework for iOS/OSX."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"MichaelLedger"=>"MichaelLedger@163.com"}
  s.homepage = "https://github.com/MichaelLedger/YYModel"
  s.social_media_url = "https://michaelledger.github.io/blog/developer.html"
  s.frameworks = ["Foundation", "CoreFoundation"]
  s.requires_arc = true
  s.source = { :path => '.' }

  s.ios.deployment_target    = '12.0'
  s.ios.vendored_framework   = 'ios/YYModel.framework'
  s.osx.deployment_target    = '10.13'
  s.osx.vendored_framework   = 'osx/YYModel.framework'
end
