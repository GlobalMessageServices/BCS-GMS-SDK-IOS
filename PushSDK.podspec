Pod::Spec.new do |s|
  s.name             = "PushSDK"
  s.version          = "1.1.3"
  s.summary          = "SDK for sending push messages to iOS devices."
  s.homepage         = "https://github.com/GlobalMessageServices/BCS-GMS-SDK-IOS"
  
  
  #s.license          = { :type => 'MIT', :file => 'LICENSE' }
  
  
  s.author           = { "o.korniienko" => "o.korniienko@gms-worldwide.com" }
  s.source           = { :git => "https://github.com/GlobalMessageServices/BCS-GMS-SDK-IOS.git", :tag =>  s.version.to_s}
 
 
  s.platform     = :ios, '13.0'
  s.requires_arc = true
  
  s.swift_version = ['3.0', '4.0', '4.2', '5.0', '5.1']
 
  #s.source_files = 'PushSDKIOS/**/*.{swift}'
  s.source_files  = "Classes", "Classes/**/*.{h,m}", "PushSDK/*.{h,m}", "PushSDK/*.swift", "PushSDK/api", "PushSDK/core", "PushSDK/settings", "PushSDK/firebase", "PushSDK/models", "PushSDK/utils"


  
s.dependency "BoringSSL-GRPC"
#s.dependency "BoringSSL-GRPC"
s.dependency "CryptoSwift"
s.dependency "SwiftyJSON", "5.0.0"
s.dependency "JSON", "5.0.0"
s.dependency 'SwiftyBeaver', "1.9.2"
s.dependency 'Firebase/Messaging'
#.dependency 'FirebaseCore'
s.dependency 'Firebase/Installations'
#s.dependency 'FirebaseInstanceID'
s.dependency 'Alamofire'
  

  
end
