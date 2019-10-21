//
//  sk_firebase.swift
//  PushDemo
//
//  Created by ard on 29/09/2019.
//  Copyright © 2019 ard. All rights reserved.
//

import Foundation
import UserNotifications
import FirebaseCore
import FirebaseInstanceID
import FirebaseMessaging
import UIKit


public class FbPush {
    
    public init() {}
    
    let gcmMessageIDKey = "gcm.message_id"
    
    public func fb_register() {
        
        
        

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
                Constants.firebase_registration_token = result.token
                UserDefaults.standard.synchronize()
                print("Remote instance ID token: \(result.token)")
            }
        }
        
    }
    
    

    
}

/*

extension AppDelegate {
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
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
        print(UIBackgroundFetchResult.newData)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
}

*/




