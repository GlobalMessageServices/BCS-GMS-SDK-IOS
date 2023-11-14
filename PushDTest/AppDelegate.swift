//
//  AppDelegate.swift
//  PushDemo
//
import UIKit
import Firebase
import FirebaseMessaging
import PushSDK



@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {
    let fb_ad = PushSDKFirebase.init()
    
    public var window: UIWindow?
    
    @IBOutlet weak var sentNotificationLabel: UILabel!
    
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        fb_ad.fbInitApplication(didFinishLaunchingWithOptions: launchOptions)
        //application.registerForRemoteNotifications()
        application.registerForRemoteNotifications()
        fb_ad.registerForPushNotifications()
        //UNUserNotificationCenter.current().delegate = self
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
        //print("received1:")
        //print(userInfo)
        fb_ad.fbInitApplication(didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        
    }
    
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        fb_ad.fbInitApplication(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    @objc func openURL(url:URL){
        //UIApplication.shared.open(url)
    }
}


