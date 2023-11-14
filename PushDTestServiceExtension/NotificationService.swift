//
//  NotificationService.swift
//  PushDTestServiceExtension
//
//  Created by o.korniienko on 16.10.23.
//  Copyright © 2023 Дмитрий Буйновский. All rights reserved.
//

import UserNotifications
import Alamofire
import PushSDK

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    //let fb_ad = PushSDKFirebase.init()

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if var bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            
            //bestAttemptContent.title = "\(bestAttemptContent.title) [modified new]"
            bestAttemptContent = preparePushNotification(content: bestAttemptContent)
            
            Task{
                await sendRequest()
            }
            
            print("in extension didReceive")
            print(bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        print("in extension serviceExtensionTimeWillExpire")
        if let contentHandler = contentHandler, var bestAttemptContent =  bestAttemptContent {
            print("in extension change 2")
            
            contentHandler(bestAttemptContent)
            print("displayed")
        }
    }
    
    
    func preparePushNotification(
        content: UNMutableNotificationContent
    ) ->UNMutableNotificationContent{
        var imageUrl: String = ""
        var contentTitle: String = ""
        //let contentSubtitle: String = ""
        var contentBody: String = ""
        var btnText: String = ""
        var btnURL: String = ""
        var is2Way: Bool = false
        var usrInfo:[AnyHashable: Any] = content.userInfo
        
        do{
            var messageAny: String = usrInfo["message"] as! String
            var json = messageAny.data(using: .utf8)
            let message:PushMessage = try! JSONDecoder().decode(PushMessage.self, from: json!)
            
            if message != nil{
                imageUrl = message.image.url
                contentTitle = message.title
                contentBody = message.body
                btnText = message.button.text
                btnURL = message.button.url
                is2Way = message.is2Way
            }
        }catch{
            
        }
       
        
        if(contentBody != ""){
            content.body = contentBody
        }
        if(contentTitle != ""){
            content.title = contentTitle + "[modified]"
        }
       
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "pushKActionCategory"
        
        var isPushActionButton = false
        if(btnURL != "" && btnText != ""){
            isPushActionButton = true
            
            let userInfoAction = content.userInfo.merging(["pushKActionButtonURL" : btnURL]){(current, _) in current}
            content.userInfo = userInfoAction
        }
        
        if(isPushActionButton || is2Way){
            setActions(btnText: btnText, isPushActionButton: isPushActionButton, is2Way: is2Way)
        }
        
        if(imageUrl != ""){
            if let url = URL(string: imageUrl){
            
                    guard let data = NSData(contentsOf: url) else{
                        return content
                    }
                    
                    let fileIdentifier = ProcessInfo.processInfo.globallyUniqueString
                    let target = FileManager.default.temporaryDirectory.appendingPathComponent(fileIdentifier).appendingPathExtension(url.pathExtension)
                    
                    do{
                        print("adding image")
                        try data.write(to: target)
                        let attachment = try UNNotificationAttachment(identifier: fileIdentifier, url: target, options: nil)
                        content.attachments.append(attachment)
                        
                    }catch{
                        print(url)
                    }
                
                
            }else{
                
            }
            
        }else{
            
        }
        return content
    }
    
    func sendRequest() async{
        let task = AF.request("https://webhook.site/373eef87-63d5-4cba-9211-25cca29f76ac", method: .post){$0.timeoutInterval = 15}.serializingString()
        let response = await task.response
        print(response)
    }
    
    // set action and reply buttons
    func setActions(btnText: String, isPushActionButton : Bool, is2Way: Bool){
        var actions: [UNNotificationAction] = []
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
    

}
