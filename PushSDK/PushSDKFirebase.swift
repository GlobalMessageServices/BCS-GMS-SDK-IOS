
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
//import FirebaseInstanceID


public class PushSDKFirebase: UIResponder, UIApplicationDelegate {
    
    let processorPush = PushKProcessing.init()
    let pushParser = PusherKParser.init()
    let manualNotificator = PushKNotification.init()
    let answerAdapter = PushKAnswParser.init()
    let push_adapter = PushSDK.init(basePushURL: PushKConstants.basePushURLactive)
    let gcmMessageIDKey = "gcm.message_id"
    let mySpecialNotificationKey = "com.push.specialNotificationKey"
    
    public var window: UIWindow?

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
    
    
    public func fbInitApplication(didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        // Override point for customization after application launch.
        
        //fbInitApplication0
        PushKConstants.logger.debug("Call fbInitApplication: fbInitApplication0")
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        //Solicit permission from user to receive notifications
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, error) in
            guard error == nil else{
                PushKConstants.logger.debug(String(error?.localizedDescription ?? ""))
                return
            }
        }
        
        //get application instance ID
        let fbToken = PushSdkFirHelpers.firebaseUpdateToken()
        PushKConstants.logger.debug("fbToken updated: \(fbToken)")

        registerForPushNotifications()
    }
    

    
    public func fbInitApplication(didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        //fbInitApplication1
        PushKConstants.logger.debug("Call fbInitApplication: fbInitApplication1")
        PushKConstants.logger.debug("application:didReceiveRemoteNotification:fetchCompletionHandler: \(userInfo)")
        completionHandler(.newData)
    }
    
    
    public func fbInitApplication(didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        //fbInitApplication2
        PushKConstants.logger.debug("Call fbInitApplication: fbInitApplication2")
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
    
    
    public func fbInitApplication(didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //fbInitApplication3
        PushKConstants.logger.debug("Call fbInitApplication: fbInitApplication3")
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
        let parsed_message = PushKAnswParser.messageIncomingJson(str_resp: newString)
        PushKConstants.logger.debug(parsed_message)
        PushKConstants.logger.debug("test step before notification")
        
        /*
        let state = UIApplication.shared.applicationState
        if state == .background || state == .inactive {
          manualNotificator.pushNotificationManualWithImage(
            image_url: String(parsed_message.message.image?.url ?? ""),
            content_title: String(parsed_message.message.title ?? ""),
            content_body: String(parsed_message.message.body ?? ""))
            PushKConstants.logger.debug("App in Background")
        }
 */
        if (PushKConstants.enableNotificationFlag == true) {
        manualNotificator.pushNotificationManualWithImage(
          image_url: String(parsed_message.message.image?.url ?? ""),
          content_title: String(parsed_message.message.title ?? ""),
          content_body: String(parsed_message.message.body ?? ""),
            userInfo: userInfo)
          PushKConstants.logger.debug("App in Background")
        }
        
        //textOutput.text = newString
        PushKConstants.logger.debug("newString: \(newString)")
        PushKConstants.logger.debug("findProcessor")
        
        let new3String = pushParser.messIdParser(message_from_push_server: jsonString ?? "")
        
        PushKConstants.logger.debug("new3String: \(new3String)")
        
        //if (PushKConstants.enableDeliveryReportAutoFlag == true) {
        //    let deliv_rep_answ = push_adapter.pushMessageDeliveryReport(message_id: new3String)
        //    PushKConstants.logger.debug("deliv_rep_answ: \(deliv_rep_answ)")
        //}
        
        if (PushKConstants.enableDeliveryReportAutoFlag == true && PushKConstants.enableNotificationFlag == true) {
            if (PushKConstants.deliveryReportLogicFlag == 1) {
                manualNotificator.areNotificationsEnabled { (notificationStatus) in
                    debugPrint(notificationStatus)
                    if (notificationStatus == true) {
                        let deliv_rep_answ = self.push_adapter.pushMessageDeliveryReport(message_id: new3String)
                        PushKConstants.logger.debug("deliv_rep_answ: \(deliv_rep_answ)")
                    }
                }
            } else if (PushKConstants.deliveryReportLogicFlag == 2)
            {
                let deliv_rep_answ = self.push_adapter.pushMessageDeliveryReport(message_id: new3String)
                PushKConstants.logger.debug("deliv_rep_answ: \(deliv_rep_answ)")
            }
        }

        NotificationCenter.default.post(name: .receivePushKData, object: nil, userInfo: userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    public func fbInitApplication(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //fbInitApplication4
        PushKConstants.logger.debug("Call fbInitApplication: fbInitApplication4")
        PushKConstants.logger.debug("APNs token retrieved: \(deviceToken)")
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
    }
}


extension PushSDKFirebase: UNUserNotificationCenterDelegate{
    
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


extension PushSDKFirebase {
    
    public func fb_notify_messaging() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: mySpecialNotificationKey), object: self)
    }
    
    public func fb_remote_messaging(remoteMessage: NSDictionary) {
        let fdf = remoteMessage as NSDictionary as? [String: AnyObject]
        guard let jsonData = (try? JSONSerialization.data(withJSONObject: fdf ?? "", options: [])) else { return  }
        let jsonString = String(data: jsonData, encoding: .utf8)
        let parsedMessage = PushKAnswParser.messageIncomingJson(str_resp: jsonString ?? "")
        PushKConstants.logger.debug(parsedMessage)
        let parsedMessageUserData = pushParser.messIdParser(message_from_push_server: jsonString ?? "")
        
        
        /*
        let state = UIApplication.shared.applicationState
        if state == .background || state == .inactive {
            manualNotificator.pushNotificationManualWithImage(
                image_url: String(parsedMessage.message.image?.url ?? ""),
                content_title: String(parsedMessage.message.title ?? ""),
                content_body: String(parsedMessage.message.body ?? ""))
            PushKConstants.logger.debug("App in Background")
        }
 */
        if (PushKConstants.enableNotificationFlag == true) {
        manualNotificator.pushNotificationManualWithImage(
            image_url: String(parsedMessage.message.image?.url ?? ""),
            content_title: String(parsedMessage.message.title ?? ""),
            content_body: String(parsedMessage.message.body ?? ""),
            userInfo: fdf ?? [:])
        }
        PushKConstants.logger.debug("App in Background")

        switch UIApplication.shared.applicationState {
        case .active:
            PushKConstants.logger.debug("active")
        case .background:
            PushKConstants.logger.debug("App is backgrounded. Next number = \(parsedMessageUserData)")
            PushKConstants.logger.debug("Background time remaining = " +
                "\(UIApplication.shared.backgroundTimeRemaining) seconds")
        case .inactive:
            break
        @unknown default:
            PushKConstants.logger.debug("Fatal application error for UIApplication.shared.applicationState")
        }
        
        if (PushKConstants.enableDeliveryReportAutoFlag == true && PushKConstants.enableNotificationFlag == true) {
            if (PushKConstants.deliveryReportLogicFlag == 1) {
                manualNotificator.areNotificationsEnabled { (notificationStatus) in
                    debugPrint(notificationStatus)
                    if (notificationStatus == true) {
                        let deliv_rep_answ = self.push_adapter.pushMessageDeliveryReport(message_id: parsedMessageUserData)
                        PushKConstants.logger.debug("deliv_rep_answ: \(deliv_rep_answ)")
                    }
                }
            } else if (PushKConstants.deliveryReportLogicFlag == 2)
            {
                let deliv_rep_answ = self.push_adapter.pushMessageDeliveryReport(message_id: parsedMessageUserData)
                PushKConstants.logger.debug("deliv_rep_answ: \(deliv_rep_answ)")
            }
        }
        
        NotificationCenter.default.post(name: .receivePushKData, object: nil, userInfo: fdf)
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


