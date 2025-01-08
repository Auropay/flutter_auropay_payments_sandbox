#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint auropay_payments_sandbox.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'auropay_payments_sandbox'
  s.version          = '0.0.1'
  s.summary          = 'A Auropay sandbox sdk.'
  s.description      = <<-DESC
A Auropay sandbox sdk.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'auropay-payments-sandbox', '1.1.4'
  s.xcconfig = { 'ENABLE_BITCODE' => 'NO', }
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
