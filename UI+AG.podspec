
Pod::Spec.new do |s|
  s.name             = 'UI+AG'
  s.version          = '0.1.0'
  s.summary          = 'UI Extension for Areeb Group'
  s.description      = 'In House UI Extensions for Areeb Group, to reuse them across our iOS apps'

  s.homepage         = 'https://gitlab.com/areeb-egypt-team/inhouse/iOS_UI-AG'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Areeb Group', :file => 'LICENSE' }
  s.author           = { 'islamshazly' => 'islam.elshazly@areebgroup.com' }
  s.source           = { :git => 'https://gitlab.com/areeb-egypt-team/inhouse/iOS_UI-AG.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/elshazly92'

  s.ios.deployment_target = '10.0'

  s.source_files = 'UI-AG/Classes/**/*'
  
  s.frameworks = 'UIKit'
  s.dependency 'Kingfisher'
end
