//
//  firebase_message_code.swift
//  PushSDK
//
//  Created by Kirill Kotov on 15/05/2020.
//  Copyright © 2020 PUSHER. All rights reserved.
//

import Foundation

import UserNotifications
import FirebaseMessaging
import FirebaseCore
import FirebaseInstanceID

class PushKFirebaseSdk: UIResponder, UIApplicationDelegate {
    
    let processor = Processing.init()
    let push_adapter = PushSDK.init(basePushURL: PushKConstants.basePushURLactive)
    public var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    let mySpecialNotificationKey = "com.hyber.specialNotificationKey"
    @IBOutlet weak var sentNotificationLabel: UILabel!
    
    
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        //Messaging.messaging().apnsToken = deviceToken
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        //Solicit permission from user to receive notifications
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, error) in
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
        }
        
        //get application instance ID
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                UserDefaults.standard.set(result.token, forKey: "firebase_registration_token")
                PushKConstants.firebase_registration_token = result.token
                UserDefaults.standard.synchronize()
                print("Remote instance ID token: \(result.token)")
            }
        }
        application.registerForRemoteNotifications()
        registerForPushNotifications()
        return true
    }
    
    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        print("application:didReceiveRemoteNotification:fetchCompletionHandler: \(userInfo)")
        completionHandler(.newData)
    }
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
        }
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        //here  is delivery report
        let jsonData = try? JSONSerialization.data(withJSONObject: userInfo, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let newString = String(jsonString).replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        //textOutput.text = newString
        print(newString)
        print ("findProcessor")
        
        let deviceid_func = self.processor.matches(for: "\"messageId\":\"(.{4,9}-.{3,9}-.{3,9}-.{3,9}-.{4,15})\"", in: newString)
        print(deviceid_func)
        
        let jsonData2 = try? JSONSerialization.data(withJSONObject: deviceid_func, options: [])
        
        
        let jsonString2 = String(data: jsonData2!, encoding: .utf8)!
        
        PushKConstants.message_buffer = jsonString2
        
        
        let new1String = String(jsonString2).replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        print(new1String)
        
        let new2String = new1String.replacingOccurrences(of: "[\"\"messageId\":\"", with: "", options: .literal, range: nil)
        let new3String = new2String.replacingOccurrences(of: "\",\"\"]", with: "", options: .literal, range: nil)
        
        print (new3String)
        
        push_adapter.push_message_delivery_report(message_id: new3String)
        NotificationCenter.default.post(name: .didReceiveData, object: nil, userInfo: userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
    }
}


public extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


extension PushKFirebaseSdk: UNUserNotificationCenterDelegate{
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        completionHandler([.alert, .sound, .badge])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        completionHandler()
    }
}


extension PushKFirebaseSdk: MessagingDelegate {
    
    @IBAction func notify() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: mySpecialNotificationKey), object: self)
    }
    
    public func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
        let fdf = remoteMessage.appData as NSDictionary as! [String: AnyObject]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: fdf, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let newString = String(jsonString).replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        //textOutput.text = newString
        print(newString)
        
        let deviceid_func = self.processor.matches(for: "\"messageId\":\"(.{4,9}-.{3,9}-.{3,9}-.{3,9}-.{4,15})\"", in: newString)
        print(deviceid_func)
        
        let jsonData2 = try? JSONSerialization.data(withJSONObject: deviceid_func, options: [])
        let jsonString2 = String(data: jsonData2!, encoding: .utf8)!
        let new1String = String(jsonString2).replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        print(new1String)
        
        let new2String = new1String.replacingOccurrences(of: "[\"\"messageId\":\"", with: "", options: .literal, range: nil)
        let new3String = new2String.replacingOccurrences(of: "\",\"\"]", with: "", options: .literal, range: nil)
        
        switch UIApplication.shared.applicationState {
        case .active:
            print("active")
        //resultsLabel.text = resultsMessage
        case .background:
            print("App is backgrounded. Next number = \(new3String)")
            print("Background time remaining = " +
                "\(UIApplication.shared.backgroundTimeRemaining) seconds")
        case .inactive:
            break
        }
        push_adapter.push_message_delivery_report(message_id: new3String)
        NotificationCenter.default.post(name: .didReceiveData, object: nil, userInfo: fdf)
    }
    
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        print(fcmToken)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    
}
