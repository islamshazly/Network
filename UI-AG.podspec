#
# Be sure to run `pod lib lint UI-AG.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UI-AG'
  s.version          = '0.1.0'
  s.summary          = 'UI Extension for Areeb Group'
  s.description      = 'In House UI Extensions for Areeb Group, to resue them across our iOS Apps'

  s.homepage         = 'https://gitlab.com/areeb-egypt-team/inhouse/iOS_UI-AG'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Areeb Group', :file => 'LICENSE' }
  s.author           = { 'islamshazly' => 'islam.elshazly@areebgroup.com' }
  s.source           = { :git => 'https://gitlab.com/areeb-egypt-team/inhouse/iOS_UI-AG.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/elshazly92'

  s.ios.deployment_target = '9.0'

  s.source_files = 'UI-AG/Classes/**/*'
  
  s.frameworks = 'UIKit'
  s.dependency 'Kingfisher' 
end
