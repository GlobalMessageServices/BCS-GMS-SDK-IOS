//
//  HyberFirebaseHelper.swift
//  Pods
//
//  Created by Taras on 10/21/16.
//
//

import UIKit
import NotificationCenter

public extension Svyazcom {
    /// An instance of `HyberFirebaseMessagingHelper`
    public static weak var firebaseMessagingHelper: HyberFirebaseMessagingHelper? = .none

}


/**
 Firebase Messaging helper `protocol`
 - Handles `UIApplicationDidBecomeActiveNotification`
 & `UIApplicationDidEnterBackgroundNotification` to connect/dissconnect `HyberFirebaseMessagingHelper`
 - Handles receiving Apple Device token, and remote notification
 
	- Note:
	[https://firebase.google.com/docs/cloud-messaging/ios/client](https://firebase.google.com/docs/cloud-messaging/ios/client)
 */
public protocol HyberFirebaseMessagingHelper: class {


    func configureFirebaseMessaging()

    /**
     Responser for `UIApplicationDidBecomeActiveNotification`.
     Connects `HyberFirebaseMessagingHelper` to Firebase Messaging server
     */
    func didBecomeActive()

    /**
     Responser for `UIApplicationDidEnterBackgroundNotification`
     Disconnects from Firebase Messaging server
     */
    func didEnterBackground()

    /**
     Configures Firebase Messaging, and sends Firebase Messaging token request
     
     - Parameter deviceToken: APNs token recieved from `AppDelegate func application(application: UIApplication,
     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)`
     */
    func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: NSData)

    /**
     Tells to `GCMService`, that remote message received
     */
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any])


    /**
     APNs token recieved from `AppDelegate func application(application: UIApplication,
     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)`
     Setted automatically by `Hyber.framework`
     */
    var deviceToken: NSData? { get }

}

/*

public extension HyberFirebaseMessagingHelper {
    /// Adds `applicationDidEnterBackground` & `applicationDidBecomeActive` observers to object.
    /// Call this function on `init()` of your object
    public func addApplicationDidObservers() {
        NotificationCenter.default.addObserver(
                                               self,
                                               selector: NSSelectorFromString("didEnterBackground"),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
                                               object: nil)

        NotificationCenter.default.addObserver(
                                               self,
                                               selector: NSSelectorFromString("didBecomeActive"),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
    }


    /// Removes all observers of object.
    /// Call this function on `deinit` of your object
    public func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }

 
}
*/
