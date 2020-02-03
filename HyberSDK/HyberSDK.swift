//
//  hybersdk.swift
//  hybersdk
//
//  Created by ard on 08/05/2019.
//  Copyright © 2019 ard. All rights reserved.
//

//import UIKit
import Foundation
import UIKit
import CryptoSwift

//import CoreData
//import FirebaseCore
//import FirebaseMessaging
//import FirebaseInstanceID

//coredata
//https://medium.com/@ankurvekariya/core-data-crud-with-swift-4-2-for-beginners-40efe4e7d1cc


public extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
    static let didCompleteTask = Notification.Name("didCompleteTask")
    static let completedLengthyDownload = Notification.Name("completedLengthyDownload")
}

public class HyberSDK {
    
    public init(user_msisdn: String, user_password: String)
    {
        Constants.registrationstatus = UserDefaults.standard.bool(forKey: "registrationstatus")
        Constants.hyber_registration_token = UserDefaults.standard.string(forKey: "hyber_registration_token")
        Constants.deviceId = UserDefaults.standard.string(forKey: "deviceId")
        Constants.firebase_registration_token = UserDefaults.standard.string(forKey: "firebase_registration_token")
    }
    
    private let processor = Processing.init()
    
    //answer codes
    //200 - Ok
    
    //answers from remote server
    //401 HTTP code – (Client error) authentication error, probably errors
    //400 HTTP code – (Client error) request validation error, probably errors
    //500 HTTP code – (Server error)
    
    //sdk errors
    //700 - internal SDK error
    //701 - already exists
    //704 - not registered
    //705 - remote server error
    //710 - unknown error
    
    //{
    //    "result":"Ok",
    //    "description":"",
    //    "code":200,
    //    "body":{
    //}
    //}
    
    
    
    
    let answer_b = AnswerBuider.init()
    
    
    
    //Процедура 1. Регистрация устройства на сервере и файербэйзе
    public func hyber_register_new(user_phone: String, user_password: String, x_hyber_sesion_id: String, x_hyber_ios_bundle_id: String, x_hyber_app_fingerprint: String, X_Hyber_Session_Id:String, X_Hyber_Client_API_Key: String)->String {
        do{
            
            if (Constants.registrationstatus==false){
                let X_Hyber_Session_Id: String = X_Hyber_Session_Id

                let hyber_rest_server = HyberAPI.init()
                let abbb = hyber_rest_server.hyber_device_register(X_Hyber_Client_API_Key: X_Hyber_Client_API_Key, X_Hyber_Session_Id: x_hyber_sesion_id, X_Hyber_IOS_Bundle_Id: x_hyber_ios_bundle_id,  device_Name:UIDevice.modelName, device_Type: Constants.localizedModel, os_Type: "ios", sdk_Version: Constants.sdkVersion, user_Pass: user_password, user_Phone: user_phone)
                
                return abbb
            }
            else {
                return answer_b.general_answer(resp_code: "701", body_json: "error", description: "Registration exists")
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return answer_b.general_answer(resp_code: "710", body_json: "error", description: "Critical error")
        }
    }
    
    //Procedure 2. Delete registration
    public func hyber_clear_current_device()->String {
        do{
            if (Constants.registrationstatus==true){
                let X_Hyber_Session_Id: String = Constants.firebase_registration_token ?? "22"
                
                let hyber_rest_server = HyberAPI.init()
                let ggg = hyber_rest_server.hyber_device_revoke(dev_list: [Constants.deviceId!], X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: Constants.hyber_registration_token!)
                return ggg
                
            } else {
                return answer_b.general_answer(resp_code: "704", body_json: "error", description: "Not registered")
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return answer_b.general_answer(resp_code: "710", body_json: "error", description: "Critical error")
        }
    }
    
    
    public func hyber_get_device_all_from_hyber() -> String {
        do{
            if (Constants.registrationstatus==true){
                let X_Hyber_Session_Id: String = Constants.firebase_registration_token ?? "22"
                let hyber_rest_server = HyberAPI.init()
                let ansss = hyber_rest_server.hyber_device_get_all(X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: Constants.hyber_registration_token!)
                print(ansss)
                
                return ansss}
            else {
                return answer_b.general_answer(resp_code: "704", body_json: "error", description: "Not registered")
            }
            
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return answer_b.general_answer(resp_code: "710", body_json: "error", description: "Critical error")
        }
    }
    
    public func hyber_send_message_callback(message_id: String, message_text: String) -> String {
        do{
            if (Constants.registrationstatus==true){
                let X_Hyber_Session_Id: String = Constants.firebase_registration_token ?? "22"
                let hyber_rest_server = HyberAPI.init()
                let anss = hyber_rest_server.hyber_message_callback(message_Id: message_id, answer: message_text, X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: Constants.hyber_registration_token!)
                
                
                return anss}
            else {
                return answer_b.general_answer(resp_code: "704", body_json: "error", description: "Not registered")
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return answer_b.general_answer(resp_code: "710", body_json: "error", description: "Critical error")
        }
    }
    
    public func hyber_message_delivery_report(message_id: String) -> String {
        do{
            if (Constants.registrationstatus==true){
                let X_Hyber_Session_Id: String = Constants.firebase_registration_token ?? "22"
                let hyber_rest_server = HyberAPI.init()
                print(X_Hyber_Session_Id)
                print(message_id)
                print(Constants.hyber_registration_token)
                
                let asaa = hyber_rest_server.hyber_message_dr(message_Id: message_id, received_At: "123123122341", X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: Constants.hyber_registration_token!)
                
                return asaa}
            else {
                return answer_b.general_answer(resp_code: "704", body_json: "error", description: "Not registered")
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return answer_b.general_answer(resp_code: "710", body_json: "error", description: "Critical error")
        }
    }
    
    public func hyber_update_registration() -> String {
        do{
            if (Constants.registrationstatus==true){
                let X_Hyber_Session_Id: String = Constants.firebase_registration_token ?? "22"
                let hyber_rest_server = HyberAPI.init()
                
                let ansss = hyber_rest_server.hyber_device_update(fcm_Token: Constants.firebase_registration_token!, os_Type: "ios", os_Version: Constants.dev_os_Version, device_Type: Constants.localizedModel, device_Name: UIDevice.modelName, sdk_Version: Constants.sdkVersion, X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token:Constants.hyber_registration_token!)
                
                return ansss}
            else {
                return answer_b.general_answer(resp_code: "704", body_json: "error", description: "Not registered")
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return answer_b.general_answer(resp_code: "710", body_json: "error", description: "Critical error")
        }
    }
    
    enum MyError: Error {
        case FoundNil(String)
    }
    
    public func hyber_get_message_history(period_in_seconds: Int) -> String {
        do {
            if (Constants.registrationstatus==true){
                let X_Hyber_Session_Id: String = Constants.firebase_registration_token ?? "22"
                let hyber_rest_server = HyberAPI.init()
                
                let ansss = hyber_rest_server.hyber_message_get_history(utc_time: period_in_seconds, X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: Constants.hyber_registration_token!)
                return ansss}
            else {
                return answer_b.general_answer(resp_code: "704", body_json: "error", description: "Not registered")
            }
        } catch  {
            print("invalid regex: \(error.localizedDescription)")
            return answer_b.general_answer(resp_code: "710", body_json: "error", description: "Critical error")
        }
    }
    
    
    public func hyber_clear_all_device()->String {
        do{
            
            if (Constants.registrationstatus==true){
                let getdev = hyber_get_device_all_from_hyber()
                
                var listdev: [String] = []
                
                
                let string1 = self.processor.matches(for: "\"id\": (\\d+)", in: getdev)
                print(string1)
                
                /*
                 let jsonData2 = try? JSONSerialization.data(withJSONObject: string1, options: [])
                 let jsonString2 = String(data: jsonData2!, encoding: .utf8)!
                 let string2 = String(jsonString2).replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
                 print(string2)
                 */
                
                for jj in string1
                {
                    print(jj)
                    let new2String = jj.replacingOccurrences(of: "\"id\": ", with: "", options: .literal, range: nil)
                    print(new2String)
                    listdev.append(new2String)
                }
                
                print(listdev)
                
                
                
                
                let X_Hyber_Session_Id: String = Constants.firebase_registration_token ?? "22"
                print(Constants.deviceId)
                print(X_Hyber_Session_Id)
                print(Constants.hyber_registration_token)
                
                let hyber_rest_server = HyberAPI.init()
                let ggg = hyber_rest_server.hyber_device_revoke(dev_list: listdev, X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: Constants.hyber_registration_token!)
                
                return ggg
                
            }
            else {
                return answer_b.general_answer(resp_code: "704", body_json: "error", description: "Not registered")
            }
            
        } catch  {
            print("invalid regex: \(error.localizedDescription)")
            return answer_b.general_answer(resp_code: "710", body_json: "error", description: "Critical error")
        }
    }
    
    public func rewrite_msisdn(newmsisdn: String) {
        
    }
    
    public func rewrite_password(newpassword: String) {
        
    }
    
    
    public func hyber_check_queue()->HyberFunAnswerGeneral {
        do{
            
            if (Constants.registrationstatus==true){
                let X_Hyber_Session_Id: String = Constants.firebase_registration_token ?? "22"
                let hyber_rest_server = HyberAPI.init()
                
                let ansss = hyber_rest_server.hyber_check_queue(X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: Constants.hyber_registration_token!)
                
                return ansss}
            else {
                return answer_b.general_answer2(resp_code: 704, body_json: "error", description: "Not registered")
            }
            
        } catch  {
            print("invalid regex: \(error.localizedDescription)")
            return answer_b.general_answer2(resp_code: 710, body_json: "error", description: "Critical error")
        }
    }

    
    
    
  
    

    
    
    
    private func test(){
        let testtt = HyberAPI.init()
        testtt.hyber_device_register(X_Hyber_Client_API_Key: "test", X_Hyber_Session_Id: "22", X_Hyber_IOS_Bundle_Id: "1234567890", device_Name:"herolte : SM-G930F", device_Type: Constants.localizedModel, os_Type: UIDevice.current.systemName, sdk_Version: Constants.sdkVersion, user_Pass:"c225db4ab8c12905f86c840620b44d61", user_Phone:"380967747874")

    }
    
    
}



extension String {
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }

}


