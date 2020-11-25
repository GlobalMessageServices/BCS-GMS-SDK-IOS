
Push-SDK-IOS

## Using SDK

Initialization firebase in AppDelegate.swift
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

Configure incoming messaging processing in ViewController.swift

```
 override func viewDidLoad() {
    super.viewDidLoad()
    
    //register in notification center
    NotificationCenter.default.addObserver(self, selector: #selector(onReceiveFromPushServer(_:)), name: .receivePushKData, object: nil)
    UNUserNotificationCenter.current().delegate = self

 }


 //processing incoming data message
 @objc func onReceiveFromPushServer(_ notification: Notification) {
    // Do something now
    let incomMessage = PushSDK.parseIncomingPush(message: notification).messageFir
    print(incomMessage.message.toString())
    textOutput.text = textOutput.text + "\n" + incomMessage.message.toString()
 }
```


Using SDK procedures

```
let pushAdapterSdk = PushSDK.init(basePushURL: "https://push.hyber.im/api/")
let registrator: PushKFunAnswerRegister = pushAdapterSdk.push_register_new(user_phone: "375291234567", user_password: "1", x_push_sesion_id: PushKConstants.firebase_registration_token ?? "", x_push_ios_bundle_id: "12345678", X_Push_Client_API_Key: "test")

pushAdapterSdk.push_update_registration()

```
