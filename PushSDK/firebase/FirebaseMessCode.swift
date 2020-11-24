
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


public class PushKFirebaseSdk: UIResponder, UIApplicationDelegate {
    
    let processorPush = PushKProcessing.init()
    let pushParser = PusherKParser.init()
    let manualNotificator = PushKNotification.init()
    let answerAdapter = AnswParser.init()
    
    let push_adapter = PushSDK.init(basePushURL: PushKConstants.basePushURLactive)
    public var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    let mySpecialNotificationKey = "com.hyber.specialNotificationKey"
    @IBOutlet weak var sentNotificationLabel: UILabel?
    
    public func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                PushKConstants.logger.debug("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            PushKConstants.logger.debug("Notification settings: \(settings)")
        }
    }
    
    
    public func fb_fun0_application(didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        // Override point for customization after application launch.
        
        //FirebaseApp.configure()
        //Messaging.messaging().delegate = self
        //Messaging.messaging().shouldEstablishDirectChannel = true
        
        //Messaging.messaging().apnsToken = deviceToken
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        //Solicit permission from user to receive notifications
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, error) in
            guard error == nil else{
                PushKConstants.logger.debug(String(error?.localizedDescription ?? ""))
                return
            }
        }
        
        //get application instance ID
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                PushKConstants.logger.debug("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                UserDefaults.standard.set(result.token, forKey: "firebase_registration_token")
                PushKConstants.firebase_registration_token = result.token
                UserDefaults.standard.synchronize()
                PushKConstants.logger.debug("Remote instance ID token: \(result.token)")
            }
        }
 

            /*
        Installations.installations().authTokenForcingRefresh(true, completion: { (token, error) in
            if let error = error {
                PushKConstants.logger.debug("Error fetching remote instance ID: \(error)")
                return
            }
            guard let token = token else { return }
            UserDefaults.standard.set(token.authToken, forKey: "firebase_registration_token")
            PushKConstants.firebase_registration_token = token.authToken
            UserDefaults.standard.synchronize()
            PushKConstants.logger.debug("Remote instance ID token: \(token.authToken)")
        })
 */
    }
    
    internal func firebase_update_token() -> String {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                PushKConstants.logger.debug("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                UserDefaults.standard.set(result.token, forKey: "firebase_registration_token")
                PushKConstants.firebase_registration_token = result.token
                UserDefaults.standard.synchronize()
                PushKConstants.logger.debug("Remote instance ID token: \(result.token)")
            }
        }
        
        return PushKConstants.firebase_registration_token ?? ""
    }
    
    public func fb_fun1_application(didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        PushKConstants.logger.debug("application:didReceiveRemoteNotification:fetchCompletionHandler: \(userInfo)")
        completionHandler(.newData)
    }
    
    
    public func fb_fun2_application(didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            PushKConstants.logger.debug("Message ID: \(messageID)")
        }
        
        // Print full message.
        PushKConstants.logger.debug("fb_fun2_application userInfo: \(userInfo)")
    }
    
    
    public func fb_fun3_application(didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            PushKConstants.logger.debug("Message ID: \(messageID)")
        }
        
        // Print full message.
        PushKConstants.logger.debug("userInfo: \(userInfo)")
        
        
        
        //here  is delivery report
        guard let jsonData = try? JSONSerialization.data(withJSONObject: userInfo, options: []) else { return  }
        let jsonString = String(data: jsonData, encoding: .utf8)
        let newString = String(jsonString ?? "").replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        let parsed_message = answerAdapter.messageIncomingJson(str_resp: newString)
        PushKConstants.logger.debug(parsed_message)
        PushKConstants.logger.debug("test another")
        
        manualNotificator.pushNotificationManualWithImage(
            image_url: String(parsed_message.message.image?.url ?? ""),
            content_title: String(parsed_message.message.title ?? ""),
            content_body: String(parsed_message.message.body ?? ""))
        
        
        //textOutput.text = newString
        PushKConstants.logger.debug("newString: \(newString)")
        PushKConstants.logger.debug("findProcessor")

        let deviceid_func = self.processorPush.matches(for: "\"messageId\":\"(.{4,9}-.{3,9}-.{3,9}-.{3,9}-.{4,15})\"", in: newString)
        PushKConstants.logger.debug("deviceid_func: \(deviceid_func)")
        
        
        
        guard let jsonData2 = (try? JSONSerialization.data(withJSONObject: deviceid_func, options: [])) else { return  }
        
        let jsonString2 = String(data: jsonData2, encoding: .utf8)
        
        PushKConstants.message_buffer = jsonString2 ?? ""
        
        let new3String = pushParser.messIdParser(message_from_push_server: jsonString ?? "")
        
        PushKConstants.logger.debug("new3String: \(new3String)")
        
        let deliv_rep_answ = push_adapter.push_message_delivery_report(message_id: new3String)
        PushKConstants.logger.debug("deliv_rep_answ: \(deliv_rep_answ)")
        NotificationCenter.default.post(name: .didReceiveData, object: nil, userInfo: userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    public func fb_fun4_application(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushKConstants.logger.debug("APNs token retrieved: \(deviceToken)")
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
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
            PushKConstants.logger.debug("Message ID: \(messageID)")
        }
        completionHandler([.alert, .sound, .badge])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            PushKConstants.logger.debug("Message ID: \(messageID)")
        }
        completionHandler()
    }
}


extension PushKFirebaseSdk {
    
    public func fb_notify_messaging() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: mySpecialNotificationKey), object: self)
    }
    
    public func fb_remote_messaging(remoteMessage: NSDictionary) {
        let fdf = remoteMessage as NSDictionary as? [String: AnyObject]
        guard let jsonData = (try? JSONSerialization.data(withJSONObject: fdf ?? "", options: [])) else { return  }
        let jsonString = String(data: jsonData, encoding: .utf8)
        let parsed_message = answerAdapter.messageIncomingJson(str_resp: jsonString ?? "")
        PushKConstants.logger.debug(parsed_message)
        let new3String = pushParser.messIdParser(message_from_push_server: jsonString ?? "")
        manualNotificator.pushNotificationManualWithImage(
            image_url: String(parsed_message.message.image?.url ?? ""),
            content_title: String(parsed_message.message.title ?? ""),
            content_body: String(parsed_message.message.body ?? ""))

        switch UIApplication.shared.applicationState {
        case .active:
            PushKConstants.logger.debug("active")
        case .background:
            PushKConstants.logger.debug("App is backgrounded. Next number = \(new3String)")
            PushKConstants.logger.debug("Background time remaining = " +
                "\(UIApplication.shared.backgroundTimeRemaining) seconds")
        case .inactive:
            break
        @unknown default:
            PushKConstants.logger.debug("Fatal application error for UIApplication.shared.applicationState")
        }
        let deliv_rep = push_adapter.push_message_delivery_report(message_id: new3String)
        PushKConstants.logger.debug("Delivery report: \(deliv_rep)")
        NotificationCenter.default.post(name: .didReceiveData, object: nil, userInfo: fdf)
    }
    
    public func fb_token_messaging(didReceiveRegistrationToken fcmToken: String) {
        PushKConstants.logger.debug("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        PushKConstants.logger.debug("fb_token_messaging fcmToken: \(fcmToken)")
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

