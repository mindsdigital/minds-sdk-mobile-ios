Pod::Spec.new do |spec|
  spec.name         = "MindsSDK"
  spec.version      = "1.0.4"
  spec.summary      = "SDK Mobile da Minds Digital para incorporar a Biometria de Voz em seu aplicativo"
  spec.description  = <<-DESC
    O SDK iOS da Minds Digital busca proporcionar de forma rápida, simplificada e abstraída as jornadas de autenticação e cadastro por meio da biometria de voz em suas aplicações.
  DESC

  spec.homepage     = "https://github.com/mindsdigital/minds-sdk-mobile-ios"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { "Minds Digital" => "meajuda@mindsdigital.net" }
  spec.social_media_url = "https://minds.digital/"

  spec.ios.deployment_target = "11.0"
  spec.swift_version = "5.0"
  spec.source       = { :git => "https://github.com/mindsdigital/minds-sdk-mobile-ios.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/MindsSDK/**/*.{h,m,swift}"
  
  spec.dependency 'Alamofire', '~> 5.5.0'
  spec.dependency 'lottie-ios', '~> 3.4.1'
  spec.dependency 'Sentry', '~> 8.7.0'
  
  spec.dependency 'YbridOpus'
  spec.dependency 'YbridOgg'
  
  #spec.ios.source_files = 'Sources/SupportingFiles/Dependencies/Copustools/*.{h,m,swift}'
  #spec.ios.resource_bundle = { 'Copustools' => ['Sources/SupportingFiles/Dependencies/Copustools/*.xib'] }
  
  spec.ios.dependency 'YbridOpus'
  spec.ios.dependency 'YbridOgg'
  #spec.ios.dependency 'Copustools'

  spec.subspec 'Copustools' do |target|
    target.source_files = 'Sources/SupportingFiles/Dependencies/Copustools/**/*.{h,m,swift}'
  end
  
  spec.subspec 'SwiftOGG' do |target|
    target.source_files = 'Sources/SwiftOGG/*.{h,m,swift}'
    target.dependency 'YbridOpus'
    target.dependency 'YbridOgg'
    #target.dependency 'Copustools'
  end
end
