#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutterplugintest.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'zikzak_inappwebview_ios'
  s.module_name      = 'zikzak_inappwebview_ios'
  s.version          = '4.0.7'
  s.summary          = 'IOS implementation of the inappwebview plugin for Flutter.'
  s.description      = <<-DESC
iOS implementation of the Flutter inappwebview plugin. A feature-rich WebView plugin for Flutter applications with support for iOS 16.0+. This plugin provides a powerful WebView widget with extensive customization options and JavaScript communication capabilities.
                       DESC
  s.homepage         = 'https://zuzu.dev'
  s.license          = { :type => 'Apache-2.0' }
  s.author           = { 'ARRRRNY' => 'arrrrny@zuzu.dev' }
  s.source           = { :git => 'https://github.com/arrrrny/zikzak_inappwebview.git', :tag => s.version.to_s }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.resources = ['Storyboards/**/*', 'PrivacyInfo.xcprivacy']

  s.dependency 'Flutter'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.

  # Removed obsolete Swift overlay libraries

  # Removed obsolete LIBRARY_SEARCH_PATHS for Swift overlays

  s.frameworks = 'WebKit'

  s.swift_version = '5.9'

  s.platforms = { :ios => '16.0' }
  s.dependency 'OrderedSet', '>= 6.0.3'

  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.platform = :ios, '16.0'
  end

  # Minimum iOS 16.0 for modern WebKit APIs and WKUIDelegate requirements
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'IPHONEOS_DEPLOYMENT_TARGET' => '16.0'
  }
end
