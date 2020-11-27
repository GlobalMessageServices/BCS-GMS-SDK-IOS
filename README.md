
# Push-SDK-IOS


***
### IMPORTANT information <br>
last actual SDK version: 1.0.0.31

Integrate PushSDK to your project with COCOAPODS (https://guides.cocoapods.org/using/the-podfile.html) <br>
```pod 'PushSDK', :git => 'https://github.com/kirillkotov/Push-SDK-IOS', :branch => 'master'```
***

## Using SDK



Important ! Before start using SDK, configure firebase project first and upload your google-services.json file into your application directory

* [Setting up your project to work with the SDK](https://github.com/kirillkotov/Push-SDK-IOS/wiki/Creating-App-Id-and-APNS-key)

* [SDK functions list](https://github.com/kirillkotov/Push-SDK-IOS/wiki/SDK-functions-description)

* [SDK answers](https://github.com/kirillkotov/Push-SDK-IOS/wiki/SDK-answers)



Then initialize firebase helper functions into your AppDelegate.swift

```
 import UIKit
 import PushSDK
 import SwiftyBeaver
 import UserNotifications

 @UIApplicationMain
 public class AppDelegate: UIResponder, UIApplicationDelegate {
    let fb_ad = PushSDKFirebase.init()
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        fb_ad.fbInitApplication(didFinishLaunchingWithOptions: launchOptions)
        //application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        fb_ad.fbInitApplication(didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        fb_ad.fbInitApplication(didReceiveRemoteNotification: userInfo)
    }
    
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        fb_ad.fbInitApplication(didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
    
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        fb_ad.fbInitApplication(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
 }
```

Put extension for processing messages in background state and kill state

```
extension AppDelegate: MessagingDelegate {
    
    @IBAction func notify() {
        fb_ad.fb_notify_messaging()
    }
    
    public func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        fb_ad.fb_remote_messaging(remoteMessage: remoteMessage.appData as NSDictionary)
    }
    
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        fb_ad.fb_token_messaging(didReceiveRegistrationToken: fcmToken )
    }
}
```

Configure processing incoming messages  in ViewController.swift

```
 override func viewDidLoad() {
    super.viewDidLoad()
    
    //register in notification center
    NotificationCenter.default.addObserver(self, selector: #selector(onReceiveFromPushServer(_:)), name: .receivePushKData, object: nil)
    UNUserNotificationCenter.current().delegate = self

 }


 //processing incoming data message function
 @objc func onReceiveFromPushServer(_ notification: Notification) {
    // Do something now
    // You can process your message here
    let incomMessage = PushSDK.parseIncomingPush(message: notification).messageFir
    print(incomMessage.message.toString())
    textOutput.text = textOutput.text + "\n" + incomMessage.message.toString()
 }
```

Then you can communicate with push platform by the following functions
[SDK functions list](https://github.com/kirillkotov/Push-SDK-IOS/wiki/SDK-functions-description)

Example using SDK functions:
```
let pushAdapterSdk = PushSDK.init(basePushURL: "https://push.example.com/api/")
let registrator: PushKFunAnswerRegister = pushAdapterSdk.pushRegisterNew(user_phone: "375291234567", user_password: "1", x_push_sesion_id: PushKConstants.firebase_registration_token ?? "", x_push_ios_bundle_id: "12345678", X_Push_Client_API_Key: "test")

pushAdapterSdk.pushUpdateRegistration()

pushAdapterSdk.pushGetDeviceAllFromServer()

pushAdapterSdk.pushClearAllDevice()

```
