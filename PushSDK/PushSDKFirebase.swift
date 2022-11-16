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
    let manualNotificator = PushNotification.init()
    let answerAdapter = PushServerAnswParser.init()
    let pushAdapter = PushSDK.init(basePushURL: PushKConstants.basePushURLactive)
    let gcmMessageIDKey = "gcm.message_id"
    let mySpecialNotificationKey = "com.push.specialNotificationKey"
    
    public var window: UIWindow?

    @IBOutlet weak var sentNotificationLabel: UILabel?
    
    public func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
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

        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
         Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let gcmMessageID = userInfo[gcmMessageIDKey] {
            PushKConstants.logger.debug("gcm essage ID: \(gcmMessageID)")
        }
        
        // Print full message.
        PushKConstants.logger.debug("fb_init_application_fun2 userInfo: \(userInfo)")
    }
    
    
    public func fbInitApplication(didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //fbInitApplication3
        PushKConstants.logger.debug("Call fbInitApplication: fbInitApplication3")

        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        
        if let gcmMessageID = userInfo[gcmMessageIDKey] {
            PushKConstants.logger.debug("gcm message ID: \(gcmMessageID)")
            
        }
        
        // Print full message.
        PushKConstants.logger.debug("userInfo: \(userInfo)")
        
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: userInfo, options: []) else { return  }
        let jsonString = String(data: jsonData, encoding: .utf8)
        PushKConstants.logger.debug("jsonString: \(jsonString ?? "empty")")
        let newString = String(jsonString ?? "").replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        PushKConstants.logger.debug("newString: \(newString)")
        let parsedMessage = PushServerAnswParser.messageIncomingJson(strResp: newString)
        PushKConstants.logger.debug("parsedMessage: \(parsedMessage)")
        
    
        if (PushKConstants.enableNotificationFlag == true) {
            manualNotificator.preparePushNotification(
                imageUrl: String(parsedMessage.message.image?.url ?? ""),
                contentTitle: String(parsedMessage.message.title ?? ""),
                contentBody: String(parsedMessage.message.body ?? ""),
                btnText: String(parsedMessage.message.button?.text ?? ""),
                btnURL: String(parsedMessage.message.button?.url ?? ""),
                userInfo: userInfo)

        }
        
        //here is delivery report sending
        let messageId = parsedMessage.message.messageId
        PushKConstants.logger.debug("messageId: \(messageId ?? "messageId error")")
        
        if (PushKConstants.enableDeliveryReportAutoFlag == true && PushKConstants.enableNotificationFlag == true) {
            if (PushKConstants.deliveryReportLogicFlag == 1) {
                let notificationStatus = pushAdapter.areNotificationsEnabled()
                
                if (notificationStatus == true) {
                    let drAnswer = self.pushAdapter.pushMessageDeliveryReport(messageId: messageId ?? "")
                    PushKConstants.logger.debug("delivery report answer: \(drAnswer)")
                }
            
            } else if (PushKConstants.deliveryReportLogicFlag == 2)
            {
                let drAnswer = self.pushAdapter.pushMessageDeliveryReport(messageId: messageId ?? "")
                PushKConstants.logger.debug("delivery report answer: \(drAnswer)")
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
        PushKConstants.logger.debug("userInfo: \(userInfo)")
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let gcmMessageID = userInfo[gcmMessageIDKey] {
            PushKConstants.logger.debug("gcm message ID: \(gcmMessageID)")
        }
        
        if #available(iOS 14.0, *){
            completionHandler([.banner, .list, .sound, .badge])
        }else{
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        PushKConstants.logger.debug("userInfo: \(userInfo)")
        
        switch response.actionIdentifier{
            case "pushKNotificationActionId":
                let urlS = userInfo["pushKActionButtonURL"]
                
                if let url = URL(string: urlS as! String){
                    UIApplication.shared.open(url)
                }
                break
            
        default:
            break
        }
        
        if let gcmMessageID = userInfo[gcmMessageIDKey] {
            PushKConstants.logger.debug("gcm message ID: \(gcmMessageID)")
        }
        
        completionHandler()
    }
}


extension PushSDKFirebase {
    
    public func fbNotifyMessaging() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: mySpecialNotificationKey), object: self)
    }
    
    public func fb_remote_messaging(remoteMessage: NSDictionary) {
        let fdf = remoteMessage as NSDictionary as? [String: AnyObject]
        guard let jsonData = (try? JSONSerialization.data(withJSONObject: fdf ?? "", options: [])) else { return  }
        let jsonString = String(data: jsonData, encoding: .utf8)
        let parsedMessage = PushServerAnswParser.messageIncomingJson(strResp: jsonString ?? "")
        PushKConstants.logger.debug(parsedMessage)
        let parsedMessageUserData = pushParser.messIdParser(messageFromPushServer: jsonString ?? "")
        PushKConstants.logger.debug("parsedMessageUserData: \(parsedMessageUserData)")
        
        
        if (PushKConstants.enableNotificationFlag == true) {
        manualNotificator.preparePushNotification(
            imageUrl: String(parsedMessage.message.image?.url ?? ""),
            contentTitle: String(parsedMessage.message.title ?? ""),
            contentBody: String(parsedMessage.message.body ?? ""),
            btnText: String(parsedMessage.message.button?.text ?? ""),
            btnURL: String(parsedMessage.message.button?.url ?? ""),
            userInfo: fdf ?? [:])
        }

        switch UIApplication.shared.applicationState {
        case .active:
            PushKConstants.logger.debug("active")
        case .background:
            PushKConstants.logger.debug("App is backgrounded.")
            PushKConstants.logger.debug("Background time remaining = " +
                "\(UIApplication.shared.backgroundTimeRemaining) seconds")
        case .inactive:
            PushKConstants.logger.debug("App is inactive.")
        @unknown default:
            PushKConstants.logger.debug("Fatal application error for UIApplication.shared.applicationState")
        }
        
        if (PushKConstants.enableDeliveryReportAutoFlag == true && PushKConstants.enableNotificationFlag == true) {
            if (PushKConstants.deliveryReportLogicFlag == 1) {
                let notificationStatus = pushAdapter.areNotificationsEnabled()
                
                if (notificationStatus == true) {
                    let drAnswer = self.pushAdapter.pushMessageDeliveryReport(messageId: parsedMessageUserData)
                    PushKConstants.logger.debug("delivery report answer: \(drAnswer)")
                }
            
            } else if (PushKConstants.deliveryReportLogicFlag == 2)
            {
                let drAnswer = self.pushAdapter.pushMessageDeliveryReport(messageId: parsedMessageUserData)
                PushKConstants.logger.debug("delivery report answer: \(drAnswer)")
            }
        }
        
        NotificationCenter.default.post(name: .receivePushKData, object: nil, userInfo: fdf)
    }
    public func fb_token_messaging(didReceiveRegistrationToken fcmToken: String) {
        PushKConstants.logger.debug("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
}
