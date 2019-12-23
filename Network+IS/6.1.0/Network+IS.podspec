#
# Be sure to run `pod lib lint Network-AG.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Network+IS'
  s.version          = '6.1.0'
  s.summary          = 'Netowrk layer'
  s.homepage         = 'https://github.com/islamshazly/Network'
  s.license          = { :type => 'Islam Elshazly', :file => 'LICENSE' }
  s.author           = { 'islamshazly' => 'ishazly92.com' }
  s.source           = { :git => 'https://github.com/islamshazly/Network.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/elshazly92'
  s.ios.deployment_target = '11.0'
  s.swift_version = '4.2'
  s.source_files = 'Network-AG/Classes/**/*.{swift}'
  s.frameworks = 'Foundation'
  s.dependency 'Alamofire' 
  s.dependency 'XCGLogger'
  s.dependency 'ObjectMapper'
  s.dependency 'AlamofireObjectMapper'
  s.dependency 'RxAlamofire'
  s.dependency 'RxAlamofire+ObjectMapper'
end
