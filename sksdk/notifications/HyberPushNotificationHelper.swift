//
//  HyberPushNotification.swift
//  Pods
//
//  Created by Taras on 10/21/16.
//
//
import Foundation
import UIKit
import UserNotifications
//import SwiftyJSON
//import Realm
//import RealmSwift

/**
 The delegate of a `Hyber` object must adopt the
 `HyberRemoteNotificationReciever` protocol.
 Methods of the protocol allow the reciever to manage receiving of remote push-notifications
 */
public protocol HyberRemoteNotificationReciever: class {

    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any])
}

public extension HyberSK {

    /**
     Handles registration for push-notification receiving
     
    - Parameter deviceToken: registered remote Apple Push-notifications device doken
     */
    public static func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: NSData) {
        didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken)
        firebaseMessagingHelper?.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken)
        HyberLogger.info(deviceToken)
    }

    /**
     Handles receiving of push-notification
     */
    
    /*
    public static func didReceiveRemoteNotification(userInfo: [AnyHashable: Any]) {
        let validJson = JSON(userInfo)
        let aps = validJson["aps"]
        let alert = aps["alert"]
        HyberLogger.info(userInfo)
        let fcmMsgID = validJson["gcm.message_id"].rawString()
        let messageString = validJson["message"].rawString()
        if let data = messageString?.data(using: String.Encoding.utf8) {
            var json = JSON(data: data)
            let hyberMsgID = json["messageId"].rawString()
            
            DataRealm.saveNotification(json: json, message: alert)
           
            if hyberMsgID != "null" {
                HyberLogger.info("Recieved message that was sended by Hyber")
                Hyber.sentDeliveredStatus(messageId: hyberMsgID!)
            }
            
            if fcmMsgID != .none {
                if hyberMsgID == "null" {
                    HyberLogger.info("Recieved message that was sended by Firebase Messaging, but not from Hyber")
                }
            } else {
                HyberLogger.info("Recieved message that was sended by Hyber via APNs")
            }
        }
    }

*/
}


