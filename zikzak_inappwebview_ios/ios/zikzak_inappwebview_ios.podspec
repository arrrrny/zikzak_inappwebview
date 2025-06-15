#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutterplugintest.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'zikzak_inappwebview_ios'
  s.version          = '2.3.0'
  s.summary          = 'IOS implementation of the inappwebview plugin for Flutter.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://zikzak.wtf'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'ARRRRNY' => 'arrrrny@zikzak.wtf' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.resources = 'Storyboards/**/*.storyboard'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64',
    'SWIFT_VERSION' => '5.0',
    'ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES' => 'YES',
  }

  s.libraries = 'swiftCoreGraphics'

  s.xcconfig = {
      'LIBRARY_SEARCH_PATHS' => '$(SDKROOT)/usr/lib/swift',
  }

  s.frameworks = 'WebKit'

  s.swift_version = '5.0'

  s.platforms = { :ios => '11.0' }
  s.dependency 'OrderedSet', '~>5.0'

  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.platform = :ios, '9.0'
  end
end
