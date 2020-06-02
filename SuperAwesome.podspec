Pod::Spec.new do |s|
  s.name = 'SuperAwesome'
  s.version = '7.2.7'
  s.summary = 'SuperAwesome Mobile SDK for iOS'
  s.description = <<-DESC
                   The SuperAwesome Mobile SDK lets you to easily add COPPA compliant advertisements and other platform features, like user authentication and registration, to your apps. We try to make integration as easy as possible, so we provide all the necessary tools such as this guide, API documentation, screencasts and demo apps.
                   DESC
  s.homepage = 'https://doc.superawesome.tv/sa-mobile-sdk-ios/latest/'
  s.documentation_url = 'https://doc.superawesome.tv/sa-mobile-sdk-ios/latest/'
  s.license = {
  	:type => 'GNU GENERAL PUBLIC LICENSE Version 3',
  	:file => 'LICENSE'
  }
  s.author = {
	   'Gabriel Coman' => 'gabriel.coman@superawesome.tv'
  }
  s.ios.deployment_target = '10.0'
  s.swift_versions = ['4.2', '5.0']
  s.requires_arc = true
  s.source = {
  	:git => 'https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios.git',
  	:branch => 'master',
  	:tag => '7.2.7'
  }
  s.static_framework = false
  s.default_subspec = 'Full'

  s.subspec 'Full' do |b|
    b.source_files = 'Pod/Classes/**/*'
    b.vendored_frameworks = 'Pod/Libraries/SUPMoatMobileAppKit.framework'
    b.frameworks = 'AdSupport'
  end
  
#  s.subspec 'Core' do |c|
#    c.dependency 'SuperAwesome/Full'
#    c.source_files = 'Pod/Plugin/Core/Classes/**/*'
#
#    c.test_spec 'Tests' do |test_spec|
#      test_spec.source_files = 'Pod/Plugin/Core/Tests/**/*'
#      test_spec.dependency 'Nimble'
#      test_spec.dependency 'Mockingjay'
#    end
#  end
  
#  s.subspec 'Moya' do |m|
#    m.dependency 'SuperAwesome/Core'
#    m.source_files = 'Pod/Plugin/Moya/Classes/**/*'
#    m.dependency 'Moya', '~> 14.0'
#    m.xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) MOYA_PLUGIN' }
#
#    m.test_spec 'Tests' do |test_spec|
#      test_spec.source_files = 'Pod/Plugin/Moya/Tests/**/*', 'Pod/Plugin/Core/Tests/**/*'
#      test_spec.resources = 'Pod/Plugin/Moya/Resources/*'
#      test_spec.dependency 'Nimble'
#      test_spec.dependency 'Mockingjay'
#    end
#  end
  
#  s.subspec 'Moat' do |moat|
#    moat.dependency 'SuperAwesome/Full'
#    moat.vendored_frameworks = 'Pod/Libraries/SUPMoatMobileAppKit.framework'
#    moat.source_files = 'Pod/Plugin/Moat2/*'
#  end

#  s.subspec 'MoPub' do |m|
#    m.dependency 'SuperAwesome/Full'
#    m.dependency 'mopub-ios-sdk'
#    m.source_files = 'Pod/Plugin/MoPub/*'
#  end

# s.subspec 'Unity' do |u|
#    u.dependency 'SuperAwesome/Full'
#    u.source_files = 'Pod/Plugin/Unity/*'
# end
 
end
