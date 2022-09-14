//
//  Notifications.swift
//  PushSDK
//
//  Created by o.korniienko on 14.09.22.
//

import Foundation
import UserNotifications



class PushNotification {
    
    
    
    func areNotificationsEnabled(completion:@escaping (Bool)->Swift.Void) {
        var notificationStatus: Bool = false
        let current = UNUserNotificationCenter.current()
                current.getNotificationSettings(completionHandler: { permission in
                    switch permission.authorizationStatus  {
                    case .authorized:
                        PushKConstants.logger.debug("User granted permission for notification")
                        notificationStatus = true
                        completion(notificationStatus)
                        break
                    case .denied:
                        PushKConstants.logger.debug("User denied notification permission")
                        notificationStatus = false
                        completion(notificationStatus)
                        break
                    case .notDetermined:
                        PushKConstants.logger.debug("Notification permission haven't been asked yet")
                        notificationStatus = false
                        completion(notificationStatus)
                        break
                    case .provisional:
                        // @available(iOS 12.0, *)
                        PushKConstants.logger.debug("The application is authorized to post non-interruptive user notifications.")
                        notificationStatus = true
                        completion(notificationStatus)
                        break
                    case .ephemeral:
                        // @available(iOS 14.0, *)
                        PushKConstants.logger.debug("The application is temporarily authorized to post notifications. Only available to app clips.")
                        notificationStatus = false
                        completion(notificationStatus)
                        break
                    @unknown default:
                        PushKConstants.logger.debug("Unknow Status")
                        notificationStatus = false
                        completion(notificationStatus)
                        break
                    }
                })
    }
}



