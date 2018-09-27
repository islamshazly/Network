#
# Be sure to run `pod lib lint Network-AG.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Network+AG'
  s.version          = '0.1.0'
  s.summary          = 'Netowrk layer for Areeb Group'


  s.homepage         = 'https://gitlab.com/areeb-egypt-team-2/inhouse/ios_network'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'islamshazly' => 'islam.elshazly@areebgroup.com' }
  s.source           = { :git => 'https://gitlab.com/areeb-egypt-team-2/inhouse/ios_network.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.source_files = 'Network-AG/Classes/**/*'
  
  s.frameworks = 'Foundation'
  s.dependency 'Alamofire', '~> 4.7'
  s.dependency 'ObjectMapper', '~> 3.3'
end
