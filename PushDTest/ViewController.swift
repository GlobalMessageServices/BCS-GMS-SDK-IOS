//
//  ViewController.swift
//  PushDemo
//

// final rel

import UIKit
import PushSDK


class ViewController: UIViewController {
    

    
    
    //for production
    let pushAdapterSdk = PushSDK.init(basePushURL: "base-api-url", enableDeliveryReportAuto: false)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onReceiveFromPushServer(_:)), name: .receivePushKData, object: nil)
        //register in notification center
        UNUserNotificationCenter.current().delegate = self
    
    }
    
    @IBOutlet weak var textOutput: UITextView!
    @IBOutlet weak var txt1fiIn: UITextField!
    
    //clear message display field
    @IBAction func button1Click(_ sender: UIButton) {
        textOutput.text = ""
    }
    
    var clientKey = "client-api-key"
    
    //test button, register this device on push server
    @IBAction func button2register(_ sender: UIButton) {
        let tttt: PushKFunAnswerRegister = pushAdapterSdk.pushRegisterNew(userPhone: txt1fiIn.text ?? "1234567890", userPassword: "1", xPushIOSBundleId: "app-bundle-id", xPushClientAPIKey: clientKey)
        PushKConstants.logger.debug(tttt)
        textOutput.text = "\(String(textOutput.text))\n\(tttt.toString())"
        
        
    }
    
    //test button, check message queue on server
    @IBAction func button3core(_ sender: UIButton) {
        let queue = pushAdapterSdk.pushCheckQueue()
        PushKConstants.logger.debug(queue)
        textOutput.text = "\(String(textOutput.text))\n\(queue.toString())"
    }
    
    //test button, test collect function
    @IBAction func button4savecore(_ sender: UIButton) {
        //test

        let userData = pushAdapterSdk.getUserData()
        textOutput.text = userData.toString()
        
        pushAdapterSdk.locationCountry{(code, name) in

            self.textOutput.text = "\(String(self.textOutput.text))\n countryCode: \(code)"
            self.textOutput.text = " \(String(self.textOutput.text))\n countryName: \(name)"
        }
        
        
    }
    

    
    //clear only local deviceid
    @IBAction func button5clearself(_ sender: UIButton) {
        let tttt = pushAdapterSdk.pushClearCurrentDevice().toString()
        PushKConstants.logger.debug(tttt)
        textOutput.text = "\(String(textOutput.text))\n\(tttt)"
    }
    
    //get all devices from server registered for current msisdn
    @IBAction func button6getdevice(_ sender: UIButton) {
        let tttt = pushAdapterSdk.pushGetDeviceAllFromServer().toString()
        PushKConstants.logger.debug(tttt)
        textOutput.text = "\(String(textOutput.text))\n\(tttt)"
    }
    
    //send test callback message to specific message
    @IBAction func button7callback(_ sender: UIButton) {
        let tttt = pushAdapterSdk.pushSendMessageCallback(messageId: "09876543-5461-11ed-1234-005056098cc1", callbackText: "privet").toString()
        PushKConstants.logger.debug(tttt)
        textOutput.text = "\(String(textOutput.text))\n\(tttt)"
    }
    
    
    //send delivery report for test with fake message id
    @IBAction func button8dr(_ sender: UIButton) {
        let tttt = pushAdapterSdk.pushMessageDeliveryReport(messageId: "09876543-5461-11ed-1234-005056098cc1").toString()
        PushKConstants.logger.debug(tttt)
        textOutput.text = "\(String(textOutput.text))\n\(tttt)"
    }
    
    //token update on server test button
    @IBAction func button9update(_ sender: UIButton) {
        let tttt = pushAdapterSdk.pushUpdateRegistration().toString()
        PushKConstants.logger.debug(tttt)
        textOutput.text = "\(String(textOutput.text))\n\(tttt)"
    }
    
    //get message history test button
    @IBAction func button10gethistory(_ sender: UIButton) {
        let hist: PushKFunAnswerGetMessageHistory = pushAdapterSdk.pushGetMessageHistory(periodInSeconds: 12345)
        PushKConstants.logger.debug(hist)
        textOutput.text = "\(String(textOutput.text))\n\(hist)"
    }
    
    //clear all registered devices test button
    @IBAction func button11clearall(_ sender: Any) {
        let cle_p = pushAdapterSdk.pushClearAllDevice()
        PushKConstants.logger.debug(cle_p)
        textOutput.text = "\(String(textOutput.text))\n\(cle_p.toString())"
    }

}


public extension UIViewController{
    func hideKeyboard()    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()    {
        view.endEditing(true)    }
}
extension ViewController: UNUserNotificationCenterDelegate {
        
    //for displaying notification when app is in foreground    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("userNotificationCenter started: ViewController")
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.        
        //print("Notification center")
        //print(notification.request.content.body)
        //print(notification.request.content.title)
        //print(notification.request.content.subtitle)
        //print(notification.request.content.userInfo)
        let incomMessage = PushSDK.parseIncomingPush(message: notification.request.content.userInfo)
        print(incomMessage.messageFir.message)
        //print(incomMessage.messageFir.message.messageId ?? "")        
        textOutput.text = textOutput.text + "\n" + incomMessage.messageFir.message.toString()
        completionHandler([.alert, .badge, .sound])    }
        // For handling tap and user actions
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                let userInfo = response.notification.request.content.userInfo
        switch response.actionIdentifier{
        case "pushKNotificationActionId":
            let urlS = userInfo["pushKActionButtonURL"]
            PushKConstants.logger.debug("urlS: \(urlS)")
            if let url = URL(string: urlS as! String){
                print("I am opening")                    
                //UIApplication.shared.open(url)
                //self.extensionContext?.open(url)
                pushAdapterSdk.openUrl(url: url)
            }
        case "pushKReplyActionId":
            if let reply = (response as? UNTextInputNotificationResponse)?.userText{                    PushKConstants.logger.debug("user response: \(reply)")
                print("user response: \(reply)")
            }
        default:
            break
        }
                completionHandler()
    }
    //processing incoming data message    
    @objc func onReceiveFromPushServer(_ notification: Notification) {
        // Do something now        
        print("onReceiveFromPushServer started")
        let incomMessage = PushSDK.parseIncomingPush(message: notification).messageFir   
        //print(incomMessage.message.toString())
        //print(incomMessage.message.title ?? "")        
        //print(incomMessage.message.messageId ?? "")
        textOutput.text = textOutput.text + "\n" + incomMessage.message.toString()    }
    }
