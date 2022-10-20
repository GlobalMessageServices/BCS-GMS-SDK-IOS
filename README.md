
# Push-SDK-IOS

***
### Install and init Cocoapods.<br>
Open a terminal window and run $ sudo gem install cocoapods to instal Cocoapods.<br>
Then $ cd into your project directory and run $ pod init to create a Podfile. Important ! Before run $ pod init your project should be closed.<br>
To update dependencies in the Podfile run - $ pod update.<br>
To open your project run $ open ProjectName.xcworkspace<br>
More about Cocoapods and Podfile here - https://cocoapods.org, https://guides.cocoapods.org/using/the-podfile.html and https://guides.cocoapods.org/using/using-cocoapods.html.

### Add sdk to your project.
Last actual SDK version: 1.0.0.44<br>
To integrate PushSDK to your project with COCOAPODS (https://guides.cocoapods.org/using/the-podfile.html) add the next line in Podfile.<br>
pod 'PushSDK', :git => 'https://github.com/GlobalMessageServices/BCS-GMS-SDK-IOS', :branch => 'masterapi'

***
Important ! Before start using SDK, configure firebase project first and create App Id and APNS key.

***
## Add Firebase cloud messaging to your project
*	Create a project at https://console.firebase.google.com/ (or use an existing one).<br>
![image](https://user-images.githubusercontent.com/46021248/190978818-899f7023-9855-4c79-ad03-efb933874e6f.png)
*	Add new IOS app.<br>
![image](https://user-images.githubusercontent.com/46021248/190979252-99141b74-649e-4a46-a492-f3506c6976a1.png)
*	Do not forget to download config file GoogleService-Info.plist and add it into the root of your project.<br>
![image](https://user-images.githubusercontent.com/46021248/190979329-1776b8b2-00e9-4202-94ff-c1c46f613405.png)
*	Step 3 should be skipped.<br>
![image](https://user-images.githubusercontent.com/46021248/190979384-5b94a475-78af-49c0-8328-212ccef8c8cf.png)
*	After that you need to create App Id and APNS key by following the [instruction](https://github.com/GlobalMessageServices/BCS-GMS-SDK-IOS/wiki/Creating-App-Id-and-APNS-key).

## Using SDK
### Initialize firebase helper functions into your AppDelegate.swift:
```swift
 import UIKit
 import PushSDK
 import SwiftyBeaver
 import UserNotifications

 @UIApplicationMain
 public class AppDelegate: UIResponder, UIApplicationDelegate{
    let fb_ad = PushSDKFirebase.init()
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        fb_ad.fbInitApplication(didFinishLaunchingWithOptions: launchOptions)
        application.registerForRemoteNotifications()
        fb_ad.registerForPushNotifications()
        UNUserNotificationCenter.current().delegate = self

        return true
    }
    
   
 func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        fb_ad.fbInitApplication(didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        fb_ad.fbInitApplication(didReceiveRemoteNotification: userInfo)
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],  fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){    
        fb_ad.fbInitApplication(didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }

    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        fb_ad.fbInitApplication(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
}
```

### Configure processing incoming messages in ViewController.swift:
```swift
import UIKit
import PushSDK
import UserNotifications
import Alamofire
import JSON

class ViewController: UIViewController {

    @IBOutlet var textOutput : UITextView!

//PushSDK initialization
    let pushAdapterSdk = PushSDK.init(basePushURL: "https://example.com/push/", enableNotification: true, enableDeliveryReportAuto: true, deliveryReportLogic: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //register in notification center
        NotificationCenter.default.addObserver(self, selector: #selector(onReceiveFromPushServer(_:)), name: .receivePushKData, object: nil)
        UNUserNotificationCenter.current().delegate = self
    }
}

extension ViewController: UNUserNotificationCenterDelegate {

    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //If you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        completionHandler([.alert, .badge, .sound])
    }
    
    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        //UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    //processing incoming data message
    @objc func onReceiveFromPushServer(_ notification: Notification) {
        let incomMessage = PushSDK.parseIncomingPush(message: notification).messageFir
        textOutput.text = textOutput.text + "\n" + incomMessage.message.toString()
    } 
}

extension AppDelegate: UNUserNotificationCenterDelegate{   
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
   }
    
   public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
```
Then you can communicate with push platform by the following functions SDK functions list

## An example of registration a device:
* Init pPushSDK
```swift
let pushAdapterSdk = PushSDK.init(basePushURL: "https://push.example.com/api/")
```
* Make registration.
```swift
let registrator: PushKFunAnswerRegister = pushAdapterSdk.pushRegisterNew(user_phone: "375291234567", user_password: "1", x_push_sesion_id: PushKConstants.firebase_registration_token ?? "", x_push_ios_bundle_id: "12345678", X_Push_Client_API_Key: "test_key")
```
* IMPORTANT. Then update registration.
```swift
pushAdapterSdk.pushUpdateRegistration()
```


***
## Notification/delivery reports control
### You can enable/disable displaying notification and sending delivery reports with the following optional parameters in PushSDK:
-	enableNotification: Bool - enable/disable display notification. Default is true (enabled) 
-	enableDeliveryReportAuto: Bool - enable/disable sending delivery report. Default is true (enabled) 
-	deliveryReportLogic: Int - working if enableNotification is true and enableDeliveryReportAuto is true. Options of deliveryReportLogic:<br>
                   1 - if notification permitted in application settings, then send delivery report. Else not send report<br>
                   2 - always send delivery report if receive message
### You can check notification permission with areNotificationsEnabled() public function. You can use it in synchronous and asynchronous ways.<br>
* synchronous:
```swift
let permission = pushAdapterSdk.areNotificationsEnabled()
```
* asynchronous:
```swift
pushAdapterSdk.areNotificationsEnabled { (notificationStatus) in
    debugPrint(notificationStatus)
}

```
***

## Additional information.
* [SDK functions list](https://github.com/GlobalMessageServices/BCS-GMS-SDK-IOS/wiki/SDK-functions-description)

* [SDK answers](https://github.com/GlobalMessageServices/BCS-GMS-SDK-IOS/wiki/SDK-answers)


