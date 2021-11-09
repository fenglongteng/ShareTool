#
# Be sure to run `pod lib lint ShareTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ShareTool'
  s.version          = '0.1.0'
  s.summary          = '微信分享、qq分享pod模块化集成'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '微信分享、qq分享pod模块化集成'

  s.homepage         = 'https://github.com/fenglongteng/ShareTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fenglongteng' => '524510161@qq.com' }
  s.source           = { :git => 'https://github.com/fenglongteng/ShareTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ShareTool/Classes/**/*'
  
  s.vendored_libraries = ['ShareTool/Lib/**/*.a']
  
  s.libraries = 'z', 'c++'

  #qq 分享集成
  s.dependency 'TencentOpenAPI'

  #微信依赖库
  s.frameworks  = 'Security', 'CoreGraphics', 'WebKit','TencentOpenAPI'


  s.pod_target_xcconfig = {
    'OTHER_LDFLAGS' => '-ObjC -all_load -l"z" -l"c++"',
    'ENABLE_BITCODE' => 'YES'
  }
  
  s.public_header_files = 'ShareTool/Classes/**/*.h'


  s.subspec 'lib' do |ss|
      ss.source_files =  "ShareTool/Lib/**/*"
      ss.vendored_libraries = ['ShareTool/Lib/**/*.a']
   end
  
  # s.resource_bundles = {
  #   'ShareTool' => ['ShareTool/Assets/*.png']
  # }

end
