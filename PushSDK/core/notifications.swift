//
//  notifications.swift
//  PushSDK
//
//  Created by Kirill Kotov on 10/11/2020.
//  Copyright © 2020 PUSHER. All rights reserved.
//

import Foundation
import UserNotifications


class PushKNotification {
    
    func pushNotificationManualWithImage(image_url: String = "",
                time_delay: TimeInterval = 0.1,
                content_title: String = "",
                content_subtitle: String = "",
                content_body: String,
                userInfo: [AnyHashable: Any]
        ) {
        PushKConstants.logger.debug("push_notification_manual_wImage input: image_url: \(image_url), time_delay: \(time_delay), content_title: \(content_title), content_subtitle: \(content_subtitle), content_body: \(content_body)")
        
        let content = UNMutableNotificationContent()
        PushKConstants.pusher_counter += 1
        let ident = PushKConstants.pusher_counter
        PushKConstants.logger.debug("content.badge ident: \(ident)")
        content.badge = ident as NSNumber
        content.userInfo = userInfo
        
        if content_title != "" {content.title = content_title}
        if content_subtitle != "" {content.subtitle = content_subtitle}
        if content_body != "" {content.body = content_body}
        content.categoryIdentifier = "pushKActionCategory"
        
        content.sound = UNNotificationSound.default
        
        PushKConstants.logger.debug("push_notification_manual_wImage started")
        if (image_url != "") {
            
            if let url = URL(string: image_url) {
                
                let pathExtension = url.pathExtension
                
                let task = URLSession.shared.downloadTask(with: url) { (result, response, error) in
                    if let result = result {
                        
                        let identifier = ProcessInfo.processInfo.globallyUniqueString
                        let target = FileManager.default.temporaryDirectory.appendingPathComponent(identifier).appendingPathExtension(pathExtension)
                        
                        do {
                            try FileManager.default.moveItem(at: result, to: target)
                            
                            let attachment = try UNNotificationAttachment(identifier: identifier, url: target, options: nil)
                            content.attachments.append(attachment)
                            
                            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: time_delay, repeats: false)
                            
                            let notification = UNNotificationRequest(identifier: Date().description, content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(notification, withCompletionHandler: { (error) in
                                if let error = error {
                                    PushKConstants.logger.error("UNUserNotificationCenter error: \(error.localizedDescription)")
                                }
                            })
                        }
                        catch {
                            PushKConstants.logger.error("UNUserNotificationCenter error2: \(error.localizedDescription)")
                        }
                    } else {
                        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: time_delay, repeats: false)
                        
                        let notification = UNNotificationRequest(identifier: Date().description, content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(notification, withCompletionHandler: { (error) in
                            if let error = error {
                                PushKConstants.logger.error("UNUserNotificationCenter error3: \(error.localizedDescription)")
                            }
                        })
                    }
                }
                task.resume()
            }
            
        } else {
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: time_delay, repeats: false)
            
            let notification = UNNotificationRequest(identifier: Date().description, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(notification, withCompletionHandler: { (error) in
                if let error = error {
                    PushKConstants.logger.error("UNUserNotificationCenter error4: \(error.localizedDescription)")
                }
            })
        }
        
        PushKConstants.logger.debug("push_notification_manual_wImage finished")
        
    }
    
    
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
