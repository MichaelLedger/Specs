Pod::Spec.new do |s|
  s.name         = 'YYModel'
  s.summary      = 'High performance model framework for iOS/OSX.'
  s.version      = '1.0.7'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'MichaelLedger' => 'MichaelLedger@163.com' }
  s.social_media_url = 'https://michaelledger.github.io/blog/developer.html'
  s.homepage     = 'https://github.com/MichaelLedger/YYModel'
  
  s.swift_version = "5.0"
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.13'
  # s.watchos.deployment_target = '4.0'
  # s.tvos.deployment_target = '12.0'
  s.cocoapods_version = '>= 1.11.0'

  s.source       = { :git => 'https://github.com/MichaelLedger/YYModel.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = 'YYModel/*.{h,m}'
  s.public_header_files = 'YYModel/*.{h}'
  
  s.frameworks = 'Foundation', 'CoreFoundation'

end
