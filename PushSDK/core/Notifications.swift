//
//  Notifications.swift
//  PushSDK
//
//  Created by o.korniienko on 14.09.22.
//

import Foundation
import UserNotifications



class PushNotification {
    
    func preparePushNotification(imageUrl: String = "",
                                 timeInterval: TimeInterval = 1.7,
                              contentTitle: String = "",
                              contentSubtitle: String = "",
                              contentBody: String,
                                 btnText: String,
                                 btnURL: String,
                                 is2Way: Bool
                              userInfo: [AnyHashable: Any]
    ) {
        PushKConstants.logger.debug("makePushNotification input: imageUrl: \(imageUrl), timeInterval: \(timeInterval), contentTitle: \(contentTitle), contentSubtitle: \(contentSubtitle), contentBody: \(contentBody)")
        
        let content = UNMutableNotificationContent()
        content.userInfo = userInfo
        
        if(contentBody != ""){
            content.body = contentBody
        }
        if(contentTitle != ""){
            content.title = contentTitle
        }
        if(contentSubtitle != ""){
            content.subtitle = contentSubtitle
        }
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "pushKActionCategory"
        
        var isPushActionButton = false
        if(btnURL != "" && btnText != ""){
            isPushActionButton = true
            
            let userInfoAction = userInfo.merging(["pushKActionButtonURL" : btnURL]){(current, _) in current}
            content.userInfo = userInfoAction
        }
        
        if(isPushActionButton || is2Way){
            setActions(btnText: btnText, isPushActionButton: isPushActionButton, is2Way: is2Way)
            
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        if(imageUrl != ""){
            if let url = URL(string: imageUrl){
                Task{
                    guard let data = NSData(contentsOf: url) else{
                        PushKConstants.logger.debug("image getting error with url: \(url)")
                        makeNotification(content: content, trigger: trigger)
                        PushKConstants.logger.debug("notification without image was made")
                        return
                    }
                    
                    let fileIdentifier = ProcessInfo.processInfo.globallyUniqueString
                    let target = FileManager.default.temporaryDirectory.appendingPathComponent(fileIdentifier).appendingPathExtension(url.pathExtension)
                    
                    do{
                        try data.write(to: target)
                        let attachment = try UNNotificationAttachment(identifier: fileIdentifier, url: target, options: nil)
                        content.attachments.append(attachment)
                        
                        makeNotification(content: content, trigger: trigger)
                        PushKConstants.logger.debug("notification with image was made")
                        
                    }catch{
                        PushKConstants.logger.debug("error: \(error.localizedDescription)")
                        makeNotification(content: content, trigger: trigger)
                        PushKConstants.logger.debug("notification without image was made")
                    }
                }
                
            }else{
                makeNotification(content: content, trigger: trigger)
                PushKConstants.logger.debug("notification without image  was made - url error")
            }
            
        }else{
            
            makeNotification(content: content, trigger: trigger)
            PushKConstants.logger.debug("notification without image was made")
            
        }
        
        
    }
    
    func makeNotification(content: UNMutableNotificationContent, trigger: UNTimeIntervalNotificationTrigger){
        let request = UNNotificationRequest(identifier: Date().description, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
                PushKConstants.logger.error("UNUserNotificationCenter error: \(error.localizedDescription)")
            }
        })
    }
    
    
    // set action and reply buttons
    func setActions(btnText: String, isPushActionButton : Bool, is2Way: Bool){
        var actions: [UNNotificationAction] = []
        PushKConstants.logger.debug("start setActions, isPushActionButton: \(isPushActionButton), is2Way: \(is2Way)")
        if(isPushActionButton && is2Way){
            let acceptAction = UNNotificationAction(identifier: "pushKNotificationActionId",
                  title: btnText, options: [UNNotificationActionOptions.foreground])
            let replyAction = UNTextInputNotificationAction(identifier: "pushKReplyActionId", title: "Reply", options: [])
            
            actions.append(acceptAction)
            actions.append(replyAction)
        }else{
            if(isPushActionButton && !is2Way){
                let acceptAction = UNNotificationAction(identifier: "pushKNotificationActionId",
                      title: btnText, options: [UNNotificationActionOptions.foreground])
                
                actions.append(acceptAction)
            }else{
                let replyAction = UNTextInputNotificationAction(identifier: "pushKReplyActionId", title: "Reply", options: [])
                
                actions.append(replyAction)
            }
        }

        let pushCategory = UNNotificationCategory(identifier: "pushKActionCategory",
                                   actions: actions,
                                   intentIdentifiers: [],
                                   hiddenPreviewsBodyPlaceholder: "",
                                   options: .customDismissAction)
            
        UNUserNotificationCenter.current().setNotificationCategories([pushCategory])
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



