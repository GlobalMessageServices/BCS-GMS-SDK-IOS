# Uncomment the next line to define a global platform for your project
# platform :ios, '12.0'

target 'PushDTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for imperituroard
  #pod 'Firebase/Core'
  #pod 'Firebase/Auth'
  #pod 'Firebase/AdMob'
  #pod 'Firebase/Database'
  #pod 'Firebase/Messaging'
  #pod 'Firebase'
  #pod 'Firebase/Storage'
  #pod 'Firebase/Firestore'
  #pod 'Firebase/Installations'
  #pod 'Google-Mobile-Ads-SDK'
  pod 'CryptoSwift', '1.0.0'
  #pod 'PushSDK', :git => 'https://github.com/GlobalMessageServices/BCS-GMS-SDK-IOS', :branch => 'main'
  pod 'PushSDK', :git => 'https://github.com/GlobalMessageServices/BCS-GMS-SDK-IOS', :branch => 'develop'

  pod 'JSON'
  pod 'SwiftyBeaver'

  target 'PushDTestTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PushDTestUITests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PushDTestServiceExtension' do
    pod 'Alamofire'
  end

end



post_install do |installer| 
  installer.pods_project.targets.each do |target| 
    target.build_configurations.each do |config| 
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12' 
    end
  end 
end

