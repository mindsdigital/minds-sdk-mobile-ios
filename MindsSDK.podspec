Pod::Spec.new do |spec|

    spec.name         = "MindsSDK"
    spec.version      = "1.0.0"
    spec.summary      = "SDK Mobile da Minds Digital para incorporar a Biometria de Voz em seu aplicativo"
    spec.description  = <<-DESC
    O SDK iOS da Minds Digital busca proporcionar de forma rápida, simplificada e abstraída as jornadas de autenticação e cadastro por meio da biometria de voz em suas aplicações.
                     DESC
  
    spec.homepage     = "https://github.com/mindsdigital/minds-sdk-mobile-ios"
    spec.license      = { :type => 'MIT', :file => 'LICENSE' }
    spec.author             = { "Minds Digital" => "meajuda@mindsdigital.net" }
    spec.social_media_url   = "https://minds.digital/"
  
    spec.ios.deployment_target = "12.1"
    spec.swift_version = "5.0"
    spec.source       = { :git => 'https://github.com/yourusername/minds-sdk-mobile-ios.git', :tag => spec.version.to_s }

    spec.platform     = :ios, '12.1' 
  
    spec.source_files = 'Sources/**/*.swift'

    spec.resource_bundles = {
    'MindsSDKResources' => ['Sources/MindsSDK/resources/**/*.{png,json,xcassets}'],
    }

    spec.dependency 'Alamofire', '~> 5.5'
    spec.dependency 'lottie-ios', '~> 3.4.1'
    spec.dependency 'Sentry', '~> 8.7'
    spec.vendored_frameworks = 'Sources/Frameworks/*.xcframework'  # Path to your xcframeworks
  end
