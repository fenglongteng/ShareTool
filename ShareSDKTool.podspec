#
# Be sure to run `pod lib lint PrivateHelloWorld.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PrivateHelloWorld'
  s.version          = '0.1.0'
  s.summary          = 'A short description of PrivateHelloWorld.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "微信分享"

  s.homepage         = 'https://github.com/fenglongteng/PrivateHelloWorld'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = 'MIT'
  s.author           = { '524510161@qq.com' => '冯龙腾' }
  s.source           = { :git => 'https://github.com/fenglongteng/PrivateHelloWorld.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  

  s.source_files = 'PrivateHelloWorld/Classes/**/*'

  
  s.vendored_libraries = ['PrivateHelloWorld/Lib/**/*.a']
  
  s.libraries = 'z', 'c++'

  
  s.dependency 'TencentOpenAPI'

  s.frameworks  = 'Security', 'CoreGraphics', 'WebKit','TencentOpenAPI'


  s.pod_target_xcconfig = {
    'OTHER_LDFLAGS' => '-ObjC -all_load -l"z" -l"c++"',
    'ENABLE_BITCODE' => 'NO'
  }

  s.subspec 'lib' do |ss|
      ss.source_files =  "PrivateHelloWorld/Lib/**/*"
      ss.vendored_libraries = ['PrivateHelloWorld/Lib/**/*.a']
   end

  
  # s.resource_bundles = {
  #   'PrivateHelloWorld' => ['PrivateHelloWorld/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end


