//
//  PushSDKFirebase.swift
//  ToTestSDK
//
//  Created by o.korniienko on 23.08.22.
//

import Foundation

import UserNotifications
import FirebaseMessaging
import FirebaseCore


public class PushSDKFirebase: UIResponder, UIApplicationDelegate {
    
    let pushParser = PusherKParser.init()
    //let manualNotificator = PushNotification.init()
    let answerAdapter = PushServerAnswParser.init()
    let pushAdapter = PushSDK.init(basePushURL: PushKConstants.basePushURLactive)
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
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            PushKConstants.logger.debug("Message ID: \(messageID)")
        }
        
        // Print full message.
        PushKConstants.logger.debug("fb_init_application_fun2 userInfo: \(userInfo)")
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
    
    public func fbNotifyMessaging() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: mySpecialNotificationKey), object: self)
    }
    
}
