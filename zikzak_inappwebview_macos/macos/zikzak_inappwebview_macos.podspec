#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint zikzak_inappwebview_macos.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'zikzak_inappwebview_macos'
  s.version          = '4.0.0'
  s.summary          = 'macOS implementation of the zikzak_inappwebview plugin.'
  s.description      = <<-DESC
macOS implementation of the zikzak_inappwebview plugin. A feature-rich WebView plugin for Flutter applications.
                       DESC
  s.homepage         = 'https://inappwebview.dev/'
  s.license          = { :type => 'Apache-2.0' }
  s.author           = { 'ARRRRNY' => 'arrrrny@zuzu.dev' }
  s.source           = { :git => 'https://github.com/arrrrny/zikzak_inappwebview.git', :tag => s.version.to_s }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'
  s.frameworks       = 'WebKit'

  s.platform = :osx, '11.0'
  s.swift_version = '5.0'
end
