#
# Be sure to run `pod lib lint MathpixClient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MathpixClient'
  s.version          = '0.1.1'
  s.summary          = 'Simple client to work with Mathpix recognition server.'

  s.description      = <<-DESC
    This framework incapsulate requests to Mathpix server to recognite images to math. Supported output formats are latex, mathml and wolfram alpha. Framework suggest camera UI to simplify capture image.
                       DESC

  s.homepage         = 'https://github.com/Mathpix/ios-client'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DmitriDevelopment' => 'dmitridevelopment@gmail.com' }
  s.source           = { :git => 'https://github.com/Mathpix/ios-client.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'MathpixClient/Classes/**/*.{swift,h,m}'

  s.resource_bundles = {
   'Images' => ['MathpixClient/Assets/*.png','MathpixClient/Assets/*.xcassets']
  }

  # s.frameworks = 'UIKit'
  s.dependency 'PureLayout'

end
