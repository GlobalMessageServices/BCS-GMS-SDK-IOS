//
//  notifications.swift
//  PushSDK
//
//  Created by Kirill Kotov on 10/11/2020.
//  Copyright © 2020 PUSHER. All rights reserved.
//

import Foundation
import UserNotifications


public class PushKNotification {
    
    public init() {}
    
    public func pushNotificationManualWithImage(image_url: String = "",
                time_delay: TimeInterval = 0.1,
                content_title: String = "",
                content_subtitle: String = "",
                content_body: String
        ) {
        PushKConstants.logger.debug("push_notification_manual_wImage input: image_url: \(image_url), time_delay: \(time_delay), content_title: \(content_title), content_subtitle: \(content_subtitle), content_body: \(content_body)")
        
        let content = UNMutableNotificationContent()
        PushKConstants.pusher_counter += 1
        let ident = PushKConstants.pusher_counter
        PushKConstants.logger.debug("content.badge ident: \(ident)")
        content.badge = ident as NSNumber
        
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
    
    
}
