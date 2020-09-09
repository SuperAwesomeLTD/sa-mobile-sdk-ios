Pod::Spec.new do |s|
  s.name = 'SuperAwesome'
  s.version = '7.2.13'
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
  	:tag => '7.2.13'
  }
  s.static_framework = false
  s.default_subspec = 'Full'

  s.subspec 'Full' do |b|
    b.dependency 'SuperAwesome/Base'
    b.dependency 'SuperAwesome/Moat'
  end
  
  s.subspec 'Base' do |b|
    b.source_files = 'Pod/Classes/**/*'
  end
  
  s.subspec 'MoPub' do |m|
    m.dependency 'SuperAwesome/Full'
    m.dependency 'mopub-ios-sdk'
    m.source_files = 'Pod/Plugin/MoPub/*'
    m.xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) MOPUB_PLUGIN',
                   'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) MOPUB_PLUGIN=1' }
  end

  s.subspec 'Moat' do |moat|
    moat.dependency 'SuperAwesome/Base'
    moat.vendored_frameworks = 'Pod/Libraries/SUPMoatMobileAppKit.framework'
    moat.source_files = 'Pod/Plugin/Moat2/*'
  end

  s.subspec 'Core' do |c|
#    c.dependency 'SuperAwesome/Full'
    c.source_files = 'Pod/Plugin/Core/Classes/**/*'

    c.test_spec 'Tests' do |test_spec|
      test_spec.source_files = 'Pod/Plugin/Core/Tests/**/*'
      test_spec.dependency 'Nimble'
      test_spec.dependency 'Mockingjay'
    end
  end
  
  s.subspec 'Dependencies' do |m|
    m.dependency 'SuperAwesome/Core'
    m.source_files = 'Pod/Plugin/Dependencies/Classes/**/*'
    m.dependency 'SwiftyXMLParser', '~> 5.0'
    m.dependency 'Moya', '~> 14.0'
    m.dependency 'SAVideoPlayer', '~> 2.0'

    m.xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) DEPENDENCIES_PLUGIN' }

    m.test_spec 'Tests' do |test_spec|
      test_spec.source_files = 'Pod/Plugin/Dependencies/Tests/**/*', 'Pod/Plugin/Core/Tests/**/*'
      test_spec.resources = 'Pod/Plugin/Dependencies/Resources/*'
      test_spec.dependency 'Nimble'
      test_spec.dependency 'Mockingjay'
    end
  end

# s.subspec 'Unity' do |u|
#    u.dependency 'SuperAwesome/Full'
#    u.source_files = 'Pod/Plugin/Unity/*'
# end
 
end
