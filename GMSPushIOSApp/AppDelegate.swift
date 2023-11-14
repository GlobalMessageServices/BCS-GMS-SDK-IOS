

import UIKit
import PushSDK
import UserNotifications
import FirebaseMessaging
import Firebase
import SwiftyBeaver


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    let fb_ad = PushSDKFirebase.init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        FirebaseApp.configure()
        fb_ad.fbInitApplication(didFinishLaunchingWithOptions: launchOptions)
        
        
        
        application.registerForRemoteNotifications()
        fb_ad.registerForPushNotifications()
        
        UNUserNotificationCenter.current().delegate = self
        
        
        return true
    }
    
    

    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        PushKConstants.logger.debug("receive1")
        print("receive1")
        fb_ad.fbInitApplication(didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        
    }
         
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        PushKConstants.logger.debug("receive2")
        print("receive2")
        fb_ad.fbInitApplication(didReceiveRemoteNotification: userInfo)
        
    }
         
         
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PushKConstants.logger.debug("receive3")
        print("receive3")
        fb_ad.fbInitApplication(didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        
    }
         
         
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        fb_ad.fbInitApplication(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        
    }
    
  

}

