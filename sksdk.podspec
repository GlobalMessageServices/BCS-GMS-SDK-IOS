#
#  Be sure to run `pod spec lint sksdk.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "sksdk"
  spec.version      = "0.0.23"
  spec.summary      = "A short description of sksdk."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = <<-DESC
  This is SDK for sk. afa fdfasdf asdf hfdghfg hdfgh gh dfg hdfgh dfgh dfgh dfghd hd
                   DESC

  spec.homepage     = "https://www.facebook.com/ard"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author             = { "ard" => "imperituro.ard@gmail.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # spec.platform     = :ios
  # spec.platform     = :ios, "5.0"
  spec.platform              = :ios, '10.0'

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source       = { :git => "https://github.com/Incuube/Hyber-SVC-SDK-iOS.git", :tag => "#{spec.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  spec.source_files  = "Classes", "Classes/**/*.{h,m}", "sksdk/*.{h,m}", "sksdk", "sksdk/api", "sksdk/core", "sksdk/settings" #, "sksdk/notifications"
  spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  spec.swift_version = '4.0'

  #spec.frameworks  = "Firebase", "FirebaseCore", "FirebaseMessaging", "FirebaseAuth", "FirebaseAnalytics", "FirebaseAnalyticsInterop", "FirebaseAuthInterop", "FirebaseDatabase", "FirebaseFirestore", "FirebaseInstanceID", "FirebaseStorage", "GTMSessionFetcher", "GoogleAppMeasurement", "GoogleUtilities", "Protobuf", "gRPC-C++", "gRPC-Core", "leveldb-library", "nanopb", "Google-Mobile-Ads-SDK"



  #spec.libraries = 'c++', 'sqlite3', 'z'

  spec.static_framework = true


  #spec.dependency "gRPC-C++"
  #spec.dependency "gRPC-Core"
  #spec.dependency "leveldb-library"
  #spec.dependency "nanopb"
  #spec.dependency "Protobuf"
  #spec.dependency "GoogleUtilities"
  #spec.dependency "GoogleAppMeasurement"
  #spec.dependency "GTMSessionFetcher"
  
  spec.dependency "BoringSSL-GRPC"
  #spec.dependency "FirebaseABTesting"
  spec.dependency "FirebaseRemoteConfig"
  #spec.dependency "Firebase"
  #spec.dependency "FirebaseAnalytics"
  #spec.dependency "FirebaseAnalyticsInterop"
  #spec.dependency "FirebaseAuthInterop"
  #spec.dependency "FirebaseInstanceID"
  spec.dependency "CryptoSwift"


  spec.dependency "Firebase"

  spec.dependency "Firebase/Core"
  spec.dependency "Firebase/Messaging"
  spec.dependency "Firebase/Auth"
  #spec.dependency "Firebase/Database"
  #spec.dependency "Firebase/Storage"
  spec.dependency "Firebase/Firestore"
  spec.dependency "Google-Mobile-Ads-SDK"
  #spec.dependency "SwiftyJSON"


  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"
  #spec.library   = "SwiftyJSON"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true
  spec.requires_arc          = true

  spec.xcconfig = { 'LIBRARY_SEARCH_PATHS' => "$(SRCROOT)/Pods/**" }

  #spec.xcconfig = {
  #  'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(SRCROOT)/Pods/FirebaseCore $(SRCROOT)/Pods/FirebaseRemoteConfig $(SRCROOT)/Pods/FirebaseInstanceID $(SRCROOT)/Pods/FirebaseAnalytics $(SRCROOT)/Pods/FirebaseABTesting'
  #}

  spec.pod_target_xcconfig = {
    'OTHER_LDFLAGS' => '$(inherited) -ObjC'
  }


  #spec.subspec 'Core' do |core|
  #  core.platform = :ios, '8.0'
  #  core.public_header_files = 'Core/FirebaseCore/*.h'
  #  core.source_files = 'Core/FirebaseCore/*.{h,m}'
  #  core.dependency 'Firebase/Core'
  #  core.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(PODS_ROOT)/sksdk/FirebaseCore' }
  #end


  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
