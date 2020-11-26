
Push-SDK-IOS

## Using SDK


***
IMPORTANT information
last actual version SDK 1.0.0.31
***

Important ! Before start using SDK, configure firebase project first and upload your google-services.json file into your project

* [Setting up your project to work with the SDK](https://github.com/kirillkotov/Push-SDK-IOS/wiki/Creating-App-Id-and-APNS-key)

Then add firebase functions into your AppDelegate.swift

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
    // You can process your message here
    let incomMessage = PushSDK.parseIncomingPush(message: notification).messageFir
    print(incomMessage.message.toString())
    textOutput.text = textOutput.text + "\n" + incomMessage.message.toString()
 }
```


Using SDK functions

```
let pushAdapterSdk = PushSDK.init(basePushURL: "https://push.example.com/api/")
let registrator: PushKFunAnswerRegister = pushAdapterSdk.pushRegisterNew(user_phone: "375291234567", user_password: "1", x_push_sesion_id: PushKConstants.firebase_registration_token ?? "", x_push_ios_bundle_id: "12345678", X_Push_Client_API_Key: "test")

pushAdapterSdk.pushUpdateRegistration()

```

Full list of SDK functions

* New device registration
```
pushRegisterNew(user_phone: String, user_password: String, x_push_sesion_id: String, x_push_ios_bundle_id: String, X_Push_Client_API_Key: String)->PushKFunAnswerRegister

pushRegisterNew(user_phone: String, user_password: String, x_push_ios_bundle_id: String, X_Push_Client_API_Key: String)->PushKFunAnswerRegister
```

* Clear local device on server
```
pushClearCurrentDevice()->PushKGeneralAnswerStruct
```

* get message history
```
public func pushGetMessageHistory(period_in_seconds: Int) -> PushKFunAnswerGetMessageHistory
```

* Get all devices from server
```
pushGetDeviceAllFromServer() -> PushKFunAnswerGetDeviceList
```

* update firebase token on push server
```
pushUpdateRegistration() -> PushKGeneralAnswerStruct
```

* message callback
```
pushSendMessageCallback(message_id: String, message_text: String) -> PushKGeneralAnswerStruct
```

* Send delivery report to server
```
pushMessageDeliveryReport(message_id: String) -> PushKGeneralAnswerStruct
```

* Clear all devices registered with current msisdn
```
pushClearAllDevice()->PushKGeneralAnswerStruct
```
