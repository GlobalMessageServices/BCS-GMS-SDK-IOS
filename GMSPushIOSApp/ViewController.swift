

import UIKit
import PushSDK


class ViewController: UIViewController {
    
    @IBOutlet var textOutput : UITextView!
    @IBOutlet var historyBtn : UIButton!
    @IBOutlet var queueBtn : UIButton!
    @IBOutlet var changeNumBtn : UIButton!
    @IBOutlet var tesBtn : UIButton!
    
    let pushSDK : PushSDK = PushSDK.init(basePushURL: "base-api-url", enableNotification: true, enableDeliveryReportAuto: true, deliveryReportLogic:1)
    
    
    
    
    
    var messages :[(date : String, title : String, body : String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set badge number too 0 when application is launched
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        view.backgroundColor = .systemCyan
        textOutput.backgroundColor = .systemCyan
        self.title = "GMS Push"
        
        
        
        
        //register in notification center
        NotificationCenter.default.addObserver(self, selector: #selector(onReceiveFromPushServer(_:)), name: .receivePushKData, object: nil)
        UNUserNotificationCenter.current().delegate = self

        
            //check whether the device is registered
            if(!isDeviceregistered()){
                
                //redirect to registration
                guard let vc = storyboard?.instantiateViewController(identifier: "auth") as? AuthViewController else {
                    return
                }
                vc.title = "Authorisation"
                vc.navigationItem.largeTitleDisplayMode = .never
            
                vc.mainController = self
                vc.pushSDK = pushSDK
                navigationController?.setViewControllers([vc], animated: true)
            }else{
                //set message data
                messages = getMessages()
                let lastMessage = getLastMessage()
                var text : String
                if(messages.count > 0){
                    text = CustomFormatter.formateDate(input: lastMessage.date) + "\n" + lastMessage.title + "\n" + lastMessage.body
                
                }else{
                    text =  lastMessage.date + "\n" + lastMessage.title + "\n" + lastMessage.body
                }
            
                textOutput.text = text
            }
            
        
            
        
        
    }
    
    //whenever push notification is received it appears here
//    @objc func onReceiveFromPushServer(_ notification: Notification) {
//        let incomMessage = PushSDK.parseIncomingPush(message: notification).messageFir.message
//        //let incomMessage = parseIncomingPushMessage(notification: notification)
//        let text = CustomFormatter.formateDate(input: incomMessage.time ?? "") + "\n" + (incomMessage.title ?? "") + "\n" + (incomMessage.body ?? "")
//        if(!text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
//            messages.append((date:incomMessage.time ?? "", title:incomMessage.title ?? "", body: incomMessage.body ?? ""))
//
//            DispatchQueue.main.async {[weak self] in
//                guard self != nil else {return}
//
//                self?.textOutput.text = text
//               // self?.pushSDK.pushMessageDeliveryReport(message_id: incomMessage.messageId ?? "")
//
//            }
//        }
//
//     }
    
    //custom parse incoming push nootification
    private func parseIncomingPushMessage ( notification : Notification) ->MessagesResponseStr{
        var message : MessagesResponseStr = MessagesResponseStr()
        let messageString = (notification.userInfo?["message"] ?? "") as! String
        
        if(!messageString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
            let data = messageString.data(using: .utf8)!
            message = try! JSONDecoder().decode(MessagesResponseStr.self, from: data)
            
        }
        
        return message;
    }
    
    
    
    //check whether the device is registered
    func isDeviceregistered()-> Bool{
        
        var isRegistered = false
        let registrationData = pushSDK.pushGetDeviceAllFromServer();

        if(registrationData.code == 200 && registrationData.body != nil){
            isRegistered = true
        }
        return isRegistered
        
        //return PushKConstants.registrationstatus;
    }
    
    //get all push notifications from push service
    private func getMessages()->[(date : String, title : String, body : String)]{
        var result : [(date : String, title : String, body : String)] = []
        let response = pushSDK.pushGetMessageHistory(period_in_seconds: 604800)
        
        if let messageListc = response.body?.messages{
            for mss in messageListc{
                result.append((date:mss.time ?? "", title:mss.title ?? "", body: mss.body ?? ""))
                
            }
        }
        
        
        return result
    }
    
    //get last push notification from list of messages
    private func getLastMessage() -> (date : String, title : String, body : String){
        var result : (date : String, title : String, body : String) = ((date: "no data", title : "no data", body: "no data"))
        
        var indxDay : Date = Date(timeIntervalSince1970: -1)
        if(messages.count > 0){
            
            for mss in messages{
                let dateFoormater = DateFormatter()
                dateFoormater.timeZone = TimeZone(abbreviation: "UTC")
                dateFoormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let dateStr = mss.date.split(separator: ".")[0]
            
                let mssDate = dateFoormater.date(from: String(dateStr))
                if(mssDate! > indxDay){
                    indxDay = mssDate!
                    result = mss
                }
            }
        }
        
        return result
    }
    
    
    
    
    
    // show all push notifications
    @IBAction func showMessagesistory(){
        guard let vc = storyboard?.instantiateViewController(identifier: "messages") as? MessagesViewController else{
            return
        }
        
        
        
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Messages"
        vc.messages = messages
      
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //go to registration page
    @IBAction func goToChangeNumber(){
        guard let vc = storyboard?.instantiateViewController(identifier: "auth") as? AuthViewController else {
            return
        }
        vc.title = "Change Number"
        vc.navigationItem.largeTitleDisplayMode = .never
        
        vc.mainController = self
        vc.pushSDK = pushSDK
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //go to test page
    @IBAction func goToTests(){
        guard let vc = storyboard?.instantiateViewController(identifier: "test") as? TestViewController else {
            return
        }
        vc.title = "Tests"
        vc.navigationItem.largeTitleDisplayMode = .never
        
        vc.pushSDK = pushSDK
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //check queue
    @IBAction func getQueue(){
        
            let queueResponse = pushSDK.pushCheckQueue()
    
            if(queueResponse.code == 200){
                let queueMessages = parseQueueResponse(response: queueResponse).messages
                if(queueMessages.isEmpty){
                    showAlert(title: "QUEUE IS EMPTY", message: "There are no messages in the queue")
                }else{
                    for message in queueMessages {
                        messages.append((date:message.time ?? "", title:message.title ?? "", body: message.body ?? ""))
                    }
                    
                    //update last message on main page
                    let lastMessage = getLastMessage()
                    let text = CustomFormatter.formateDate(input: lastMessage.date ) + "\n" + (lastMessage.title ) + "\n" + (lastMessage.body )
                    textOutput.text = text
                }
            }else{
                showAlert(title: "ERROR", message: String(queueResponse.code) + " - " + queueResponse.description)
            }
            
        
    }
    
    //parse queue response
    private func parseQueueResponse(response : PushKFunAnswerGeneral) -> QueueResponse{
        var result = QueueResponse(messages: [])
        
        let queueMessagesString = response.body
        if(!queueMessagesString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
            let data = queueMessagesString.data(using: .utf8)!
            result = try! JSONDecoder().decode(QueueResponse.self, from: data)
            
        }
        
        
        return result
    }
    
    
    func showAlert(title: String, message : String){
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion:nil)
    }

}


public extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


extension ViewController: UNUserNotificationCenterDelegate {

    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        print("Notification center")
        print(notification.request.content.body)
        print(notification.request.content.title)
        print(notification.request.content.subtitle)
        print(notification.request.content.userInfo)
        let incomMessage = PushSDK.parseIncomingPush(message: notification.request.content.userInfo)
        print(incomMessage)
        print(incomMessage.messageFir.message.messageId ?? "")

        completionHandler([.alert, .badge, .sound])
    }

    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    //processing incoming data message
    @objc func onReceiveFromPushServer(_ notification: Notification) {
        // Do something now
        let incomMessage = PushSDK.parseIncomingPush(message: notification).messageFir.message
        //let incomMessage = parseIncomingPushMessage(notification: notification)
        let text = CustomFormatter.formateDate(input: incomMessage.time ?? "") + "\n" + (incomMessage.title ?? "") + "\n" + (incomMessage.body ?? "")
        if(!text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
            messages.append((date:incomMessage.time ?? "", title:incomMessage.title ?? "", body: incomMessage.body ?? ""))

            DispatchQueue.main.async {[weak self] in
                guard self != nil else {return}

                self?.textOutput.text = text
               // self?.pushSDK.pushMessageDeliveryReport(message_id: incomMessage.messageId ?? "")

            }
        }
    }

}


extension AppDelegate: UNUserNotificationCenterDelegate{

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
