//
//  push_adapter.swift
//  test222
//
//  Created by Kirill Kotov on 16/04/2019.
//  Copyright © 2019 ard. All rights reserved.
//

import Foundation
import CryptoSwift

//import RetrofireSwift

class PushKAPI {
    
    private let jsonparser = AnswParser.init()
    private let push_database_adapter = PushKDatabase.init()
    
    private let processor = PushKProcessing.init()
    private let answer_buider = AnswerBuider.init()
    let answer_b = AnswerBuider.init()
    
    //rest function for device registration
    //1 procedure
    func push_device_register(X_Push_Client_API_Key: String, X_Push_Session_Id: String, X_Push_IOS_Bundle_Id: String, device_Name:String, device_Type:String, os_Type:String, sdk_Version:String, user_Pass:String, user_Phone:String)-> PushKFunAnswerRegister {
        
            PushKConstants.logger.debug("Start function push_device_register")
        

            //var answ: String = String()
            var genAnsw: PushKFunAnswerRegister = PushKFunAnswerRegister(code: 0, result: "", description: "", deviceId: "", token: "", userId: "", userPhone: "", createdAt: "")
            
            let semaphore7 = DispatchSemaphore(value: 0)
            
            let os_Version = PushKConstants.dev_os_Version
            let configuration = URLSessionConfiguration .default
            let session = URLSession(configuration: configuration)
            let params =  [
                "deviceName": device_Name,
                "deviceType": device_Type,
                "osType": os_Type,
                "osVersion": os_Version,
                "sdkVersion": sdk_Version,
                "userPass": user_Pass,
                "userPhone": user_Phone
                ] as Dictionary<String, AnyObject>
            
            let urlString = NSString(format: PushKConstants.platform_branch_active.url_Http_Registration as NSString);
            PushKConstants.logger.debug("push_device_register url string is \(urlString)")
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            //var result = "" as? [[String: Any]];
            
            request.url = URL(string: NSString(format: "%@", urlString)as String)
            request.httpMethod = "POST"
            request.timeoutInterval = 30
            
            //headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(X_Push_Client_API_Key, forHTTPHeaderField: "X-Hyber-Client-API-Key")
            request.addValue(X_Push_Session_Id, forHTTPHeaderField: "X-Hyber-Session-Id")
            request.addValue(X_Push_IOS_Bundle_Id, forHTTPHeaderField: "X-Hyber-IOS-Bundle-Id")
        
            do {
               request.httpBody  = try JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
               PushKConstants.logger.debug("request.httpBody error")
            }
            
            PushKConstants.logger.debug(request.httpBody ?? "")
            PushKConstants.logger.debug(request.allHTTPHeaderFields ?? "")
            
            let dataTask = session.dataTask(with: request as URLRequest)
            {
                ( data: Data?, response: URLResponse?, error: Error?) -> Void in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        PushKConstants.logger.error("error: not a valid http response")
                        semaphore7.signal()
                        return
                }
                print(httpResponse)
                
                let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? Dictionary<String, Any>

                let body_json: String = String(decoding: receivedData, as: UTF8.self)
                PushKConstants.logger.debug("push_device_register body_json from push server: \(body_json)")
                
                
                genAnsw = PushKFunAnswerRegister.init(code: httpResponse.statusCode, result: "unknown", description: "unknown", deviceId: "", token: "", userId: "", userPhone: "", createdAt: "")
                
                
                PushKConstants.logger.debug("push_device_register response jsonData is \(String(describing: jsonData))")
                
                PushKConstants.logger.debug("push_device_register response code is \(httpResponse.statusCode)")
                
                PushKConstants.logger.debug("push_device_register response data is \(String(describing: data))")
                
                PushKConstants.logger.debug("push_device_register response debugDescription is \(httpResponse.debugDescription)")
                
                
                
                switch (httpResponse.statusCode)
                {
                case 200:
                    
                    let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                    
                    PushKConstants.logger.debug(String(response ?? ""))
                    
                    let str_resp = String(response ?? "")
                    
                    PushKConstants.logger.debug(str_resp)
                    
                    let resp_register_parsed = self.jsonparser.registerJParse(str_resp: str_resp)
                    

                    genAnsw.result = "Success"
                    genAnsw.description = "Procedure completed"
                    genAnsw.createdAt = resp_register_parsed.createdAt ??  "empty"
                    genAnsw.deviceId = resp_register_parsed.deviceId ?? "unknown"
                    genAnsw.token = resp_register_parsed.token ?? "empty_token"
                    genAnsw.userId = String(resp_register_parsed.userId ?? 0)

                    self.push_database_adapter.save_data_after_register_ok(
                        user_Phone: user_Phone,
                        token: resp_register_parsed.token ?? "empty_token",
                        device_id: resp_register_parsed.deviceId ?? "unknown",
                        user_Password: user_Pass,
                        created_at: resp_register_parsed.createdAt ??  "empty",
                        user_id: String(resp_register_parsed.userId ?? 0)
                    )
                    
                    PushKConstants.logger.debug(resp_register_parsed.token ?? "")
                    
                    if response == "SUCCESS"
                    {
                        PushKConstants.logger.debug("push_device_register success response body is \(String(describing: response))")
                    }
                    
                default:
                        PushKConstants.logger.debug("push_device_register save profile POST request got response \(httpResponse.statusCode)")
                }
                //return jsonData
                semaphore7.signal()
            }
            dataTask.resume()
            semaphore7.wait()
            return genAnsw
    }
    
    //2 procedure
    //for revoke device from push server
    func push_device_revoke(dev_list: [String], X_Push_Session_Id: String, X_Push_Auth_Token:String)->PushKGeneralAnswerStruct {
            let procedure_name = "push_device_revoke"
            let configuration = URLSessionConfiguration .default
            let session = URLSession(configuration: configuration)
            var answ: PushKGeneralAnswerStruct = PushKGeneralAnswerStruct.init(code: 0, result: "unknown", description: "unknown", body: "unknown")
            let semaphore6 = DispatchSemaphore(value: 0)
            
            let params =  ["devices": dev_list] as Dictionary<String, AnyObject>
            let urlString = NSString(format: PushKConstants.platform_branch_active.url_Http_Revoke as NSString);
            
            PushKConstants.logger.debug("params: \(dev_list)")
            PushKConstants.logger.debug("push_device_revoke: \(procedure_name) url string is \(urlString)")
            PushKConstants.logger.debug("\(procedure_name) params is \"devices\": \(dev_list)")
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = URL(string: NSString(format: "%@", urlString) as String)
            request.httpMethod = "POST"
            request.timeoutInterval = 30
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.addValue("application/json", forHTTPHeaderField: "Accept")
            //request.addValue("test", forHTTPHeaderField: "X-Hyber-Client-API-Key")
            
            //request.addValue("1234567890", forHTTPHeaderField: "X-Hyber-IOS-Bundle-Id")
            //request.addValue("1", forHTTPHeaderField: "X-Hyber-App-Fingerprint")
            
            
            
            
            let timeInterval =  NSDate().timeIntervalSince1970
            let timet = Int(round(timeInterval) as Double)
            let auth_token = X_Push_Auth_Token + ":" + String(timet)
            let sha256_auth_token = auth_token.sha256()
            PushKConstants.logger.debug(sha256_auth_token)
            PushKConstants.logger.debug("\(procedure_name) request X-Hyber-Timestamp is \(String(timet))")
            request.addValue(String(timet), forHTTPHeaderField: "X-Hyber-Timestamp")
            request.addValue(X_Push_Session_Id, forHTTPHeaderField: "X-Hyber-Session-Id")
            request.addValue(sha256_auth_token, forHTTPHeaderField: "X-Hyber-Auth-Token")
            
            PushKConstants.logger.debug(request.allHTTPHeaderFields as Any)
            PushKConstants.logger.debug(request.httpBody as Any)
            PushKConstants.logger.debug(params)
            
        do {
            request.httpBody  = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            PushKConstants.logger.error("request.httpBody error")
        }
            
            let dataTask = session.dataTask(with: request as URLRequest)
            {
                ( data: Data?, response: URLResponse?, error: Error?) -> Void in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        PushKConstants.logger.error("error: not a valid http response")
                        semaphore6.signal()
                        return
                }
                
                let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? Dictionary<String, Any>
                let body_json: String = String(decoding: receivedData, as: UTF8.self)
                
                PushKConstants.logger.debug("push_device_revoke body_json from push server: \(body_json)")
                
                answ = self.answer_buider.general_answer_struct(resp_code: String(httpResponse.statusCode), body_json: body_json, description: "Success")
                
                PushKConstants.logger.debug(jsonData as Any)
                PushKConstants.logger.debug("\(procedure_name) response jsonData is \(String(describing: jsonData))")
                
                PushKConstants.logger.debug("\(procedure_name) response code is \(httpResponse.statusCode)")
                PushKConstants.logger.debug(httpResponse.statusCode)
                
                PushKConstants.logger.debug("\(procedure_name) response data is \(String(describing: data))")
                
                PushKConstants.logger.debug("\(procedure_name) response debugDescription is \(httpResponse.debugDescription)")
                
                PushKConstants.logger.debug(httpResponse.debugDescription)
                
                switch (httpResponse.statusCode)
                {
                case 200:
                    
                    let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                    
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    PushKConstants.registrationstatus = false
                    
                    UserDefaults.standard.synchronize()
                    
                    
                    if response == "SUCCESS"
                    {
                        PushKConstants.logger.debug("\(procedure_name) success response body is \(String(describing: response))")
                    }
                case 401:
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                default:
                    PushKConstants.logger.error("\(procedure_name) save profile POST request got response \(httpResponse.statusCode)")
                }
                semaphore6.signal()
            }
            dataTask.resume()
           // semaphore6.wait(timeout: DispatchTime.now() + 2)
            semaphore6.wait()
            
            return answ
    }
    
    
    //3 procedure
    //for update device from push server
    func push_device_update(fcm_Token: String, os_Type: String, os_Version: String, device_Type: String, device_Name: String, sdk_Version: String, X_Push_Session_Id: String, X_Push_Auth_Token:String) -> PushKGeneralAnswerStruct {
        PushKConstants.logger.debug("Start function push_device_update")
            let procedure_name = "push_device_update"
            let configuration = URLSessionConfiguration .default
            let session = URLSession(configuration: configuration)
            var answ: PushKGeneralAnswerStruct = PushKGeneralAnswerStruct.init(code: 0, result: "unknown", description: "unknown", body: "unknown")
            let semaphore5 = DispatchSemaphore(value: 0)
            
            let params =  [
                "fcmToken":fcm_Token,
                "osType":os_Type,
                "osVersion":os_Version,
                "deviceType":device_Type,
                "deviceName":device_Name,
                "sdkVersion":sdk_Version
                ] as Dictionary<String, AnyObject>
        let urlString = NSString(format: PushKConstants.platform_branch_active.url_Http_Update as NSString);
            PushKConstants.logger.debug("push_device_update: \(procedure_name) url string is \(urlString)")
            PushKConstants.logger.debug("\(procedure_name) params is \(params.description)")
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = URL(string: NSString(format: "%@", urlString)as String)
            request.httpMethod = "POST"
            request.timeoutInterval = 30
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            //request.addValue("test", forHTTPHeaderField: "X-Hyber-Client-API-Key")
            request.addValue(X_Push_Session_Id, forHTTPHeaderField: "X-Hyber-Session-Id")
            //request.addValue("1234567890", forHTTPHeaderField: "X-Hyber-IOS-Bundle-Id")
            //request.addValue("1", forHTTPHeaderField: "X-Hyber-App-Fingerprint")
            
            
            let timeInterval =  NSDate().timeIntervalSince1970
            let timet = Int(round(timeInterval) as Double)
            let auth_token = X_Push_Auth_Token + ":" + String(timet)
            let sha256_auth_token = auth_token.sha256()
            
            PushKConstants.logger.debug("\(procedure_name) request X-Hyber-Timestamp is \(String(timet))")
            request.addValue(String(timet), forHTTPHeaderField: "X-Hyber-Timestamp")
            request.addValue(sha256_auth_token, forHTTPHeaderField: "X-Hyber-Auth-Token")
            
            
            
        do {
            request.httpBody  = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            PushKConstants.logger.debug("request.httpBody error")
        }
            
            PushKConstants.logger.debug(request.allHTTPHeaderFields as Any)
            PushKConstants.logger.debug(params)
            
            let dataTask = session.dataTask(with: request as URLRequest)
            {
                ( data: Data?, response: URLResponse?, error: Error?) -> Void in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        PushKConstants.logger.error("error: not a valid http response")
                        semaphore5.signal()
                        return
                }
                
                let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? Dictionary<String, Any>
                let body_json: String = String(decoding: receivedData, as: UTF8.self)
                PushKConstants.logger.debug("push_device_update body_json from push server: \(body_json)")
                
                let devid_parsed = self.jsonparser.updateregistrationJParse(str_resp: body_json)
                
                answ = self.answer_buider.general_answer_struct(resp_code: String(httpResponse.statusCode), body_json: "deviceId: \(devid_parsed.deviceId)", description: "Success")
                
                PushKConstants.logger.debug("\(procedure_name) response jsonData is \(String(describing: jsonData))")
                
                PushKConstants.logger.debug("\(procedure_name) response code is \(httpResponse.statusCode)")
                
                PushKConstants.logger.debug("\(procedure_name) response data is \(String(describing: data))")
                
                PushKConstants.logger.debug("\(procedure_name) response debugDescription is \(httpResponse.debugDescription)")
                
                PushKConstants.logger.debug(jsonData as Any)
                PushKConstants.logger.debug(httpResponse.statusCode)
                
                switch (httpResponse.statusCode)
                {
                case 200:
                    
                    let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                    
                    if response == "SUCCESS"
                    {
                        PushKConstants.logger.debug("\(procedure_name) success response body is \(String(describing: response))")                }
                case 401:
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                default:
                    PushKConstants.logger.error("\(procedure_name) save profile POST request got response \(httpResponse.statusCode)")
                }
                semaphore5.signal()
            }
            dataTask.resume()
            semaphore5.wait()
            
            return answ
    }
    
    
    
    //4 procedure
    //for get message history device from push server
    func push_message_get_history(utc_time: Int, X_Push_Session_Id: String, X_Push_Auth_Token:String)->PushKFunAnswerGetMessageHistory {
            var answ: PushKFunAnswerGetMessageHistory = PushKFunAnswerGetMessageHistory.init(code: 0, result: "unknown", description: "unknown", body: nil)
            let procedure_name = "push_message_get_history"
            let configuration = URLSessionConfiguration .default
            let session = URLSession(configuration: configuration)
            let semaphore4 = DispatchSemaphore(value: 0)
            
            let escaped_utc = String(utc_time).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
        let urlString = NSString(format: "\(PushKConstants.platform_branch_active.url_Http_Mess_history)\(String(describing: escaped_utc))" as NSString);
            PushKConstants.logger.debug("push_message_get_history: \(procedure_name) url string is \(urlString)")
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = URL(string: NSString(format: "%@", urlString) as String)
            request.httpMethod = "GET"
            request.timeoutInterval = 30
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            //request.addValue("test", forHTTPHeaderField: "X-Hyber-Client-API-Key")
            request.addValue(X_Push_Session_Id, forHTTPHeaderField: "X-Hyber-Session-Id")
            //request.addValue("1234567890", forHTTPHeaderField: "X-Hyber-IOS-Bundle-Id")
            //request.addValue("1", forHTTPHeaderField: "X-Hyber-App-Fingerprint")
            
            
            let timeInterval =  NSDate().timeIntervalSince1970
            let timet = Int(round(timeInterval) as Double)
            let auth_token = X_Push_Auth_Token + ":" + String(timet)
            let sha256_auth_token = auth_token.sha256()
            
            PushKConstants.logger.debug("\(procedure_name) request X-Hyber-Timestamp is \(String(timet))")
            request.addValue(String(timet), forHTTPHeaderField: "X-Hyber-Timestamp")
            request.addValue(sha256_auth_token, forHTTPHeaderField: "X-Hyber-Auth-Token")
            
            PushKConstants.logger.debug(request.allHTTPHeaderFields as Any)
            PushKConstants.logger.debug(request.httpBody as Any)
            

            let dataTask = session.dataTask(with: request as URLRequest)
            {
                ( data: Data?, response: URLResponse?, error: Error?) -> Void in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        PushKConstants.logger.error("error: not a valid http response")
                        semaphore4.signal()
                        return
                }
                
                let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? Dictionary<String, Any>
                //////self.logger.file_logger(message: "\(procedure_name) response jsonData is \(jsonData??["devices"])", loglevel: ".debug")
                let body_json: String = String(decoding: receivedData, as: UTF8.self)
                PushKConstants.logger.debug("push_message_get_history body_json from push server: \(body_json)")
                
                answ.code = httpResponse.statusCode
                answ.body = self.jsonparser.getMessageHistoryJson(str_resp: body_json)
                
                //answ = self.answer_buider.general_answer(resp_code: String(httpResponse.statusCode), body_json: body_json, description: "Success")
                
                
                PushKConstants.logger.debug("\(procedure_name) response jsonData is \(String(describing: jsonData))")
                
                PushKConstants.logger.debug("\(procedure_name) response code is \(httpResponse.statusCode)")
                
                PushKConstants.logger.debug("\(procedure_name) response data is \(String(describing: data))")
                
                PushKConstants.logger.debug("\(procedure_name) response debugDescription is \(httpResponse.debugDescription)")
                
                PushKConstants.logger.debug(jsonData as Any)
                PushKConstants.logger.debug(httpResponse.statusCode)
                
                switch (httpResponse.statusCode)
                {
                case 200:
                    
                    let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                    
                    answ.result = "Success"
                    
                    
                    if response == "SUCCESS"
                    {
                        PushKConstants.logger.debug("\(procedure_name) success response body is \(String(describing: response))")
                    }
                    
                    UserDefaults.standard.set(true, forKey: "registrationstatus")
                    
                case 401:
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                    
                default:
                    PushKConstants.logger.debug("\(procedure_name) save profile POST request got response \(httpResponse.statusCode)")
                }
                semaphore4.signal()
            }
            dataTask.resume()
            semaphore4.wait()
            
            return answ
    }
    
    
    //5 procedure
    //for send delivery report to push server
    func push_message_dr(message_Id: String, received_At: String, X_Push_Session_Id: String, X_Push_Auth_Token:String)->PushKGeneralAnswerStruct {
            if (message_Id != "" && message_Id != "[]" ) {
                let procedure_name = "push_message_dr"
                let configuration = URLSessionConfiguration .default
                let session = URLSession(configuration: configuration)
                var answ: PushKGeneralAnswerStruct = PushKGeneralAnswerStruct.init(code: 0, result: "unknown", description: "unknown", body: "unknown")
                let semaphore3 = DispatchSemaphore(value: 0)
                
                let params =  [
                    "messageId":message_Id
                    //"receivedAt":received_At
                    ] as Dictionary<String, AnyObject>
                let urlString = NSString(format: PushKConstants.platform_branch_active.url_Http_Mess_dr as NSString);
                PushKConstants.logger.debug("push_message_dr: \(procedure_name) url string is \(urlString)")
                PushKConstants.logger.debug("\(procedure_name) params is \(params.description)")
                
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = URL(string: NSString(format: "%@", urlString)as String)
                request.httpMethod = "POST"
                request.timeoutInterval = 30
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                //request.addValue("test", forHTTPHeaderField: "X-Hyber-Client-API-Key")
                request.addValue(X_Push_Session_Id, forHTTPHeaderField: "X-Hyber-Session-Id")
                //request.addValue("1234567890", forHTTPHeaderField: "X-Hyber-IOS-Bundle-Id")
                //request.addValue("1", forHTTPHeaderField: "X-Hyber-App-Fingerprint")
                //request.addValue(X_Hyber_Auth_Token, forHTTPHeaderField: "X-Hyber-Auth-Token")
                
                let timeInterval =  NSDate().timeIntervalSince1970
                let timet = Int(round(timeInterval) as Double)
                PushKConstants.logger.debug(X_Push_Auth_Token)
                PushKConstants.logger.debug(timet)
                let auth_token = X_Push_Auth_Token + ":" + String(timet)
                let sha256_auth_token = auth_token.sha256()
                
                PushKConstants.logger.debug(sha256_auth_token)
                PushKConstants.logger.debug("\(procedure_name) request X-Hyber-Timestamp is \(String(timet))")
                
                request.addValue(String(timet), forHTTPHeaderField: "X-Hyber-Timestamp")
                request.addValue(sha256_auth_token, forHTTPHeaderField: "X-Hyber-Auth-Token")
                
                PushKConstants.logger.debug(request.allHTTPHeaderFields as Any)
                PushKConstants.logger.debug(request.httpBody as Any)
                
                
                do {
                    request.httpBody  = try JSONSerialization.data(withJSONObject: params, options: [])
                } catch {
                    PushKConstants.logger.debug("request.httpBody error")
                }
                
                let dataTask = session.dataTask(with: request as URLRequest)
                {
                    ( data: Data?, response: URLResponse?, error: Error?) -> Void in
                    // 1: Check HTTP Response for successful GET request
                    guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                        else {
                            PushKConstants.logger.error("error: not a valid http response")
                            semaphore3.signal()
                            return
                    }
                    
                    let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? Dictionary<String, Any>
                    //////self.logger.file_logger(message: "\(procedure_name) response jsonData is \(jsonData??["devices"])", loglevel: ".debug")
                    let body_json: String = String(decoding: receivedData, as: UTF8.self)
                    PushKConstants.logger.debug("push_message_dr body_json from push server: \(body_json)")
                    
                    answ = self.answer_buider.general_answer_struct(resp_code: String(httpResponse.statusCode), body_json: body_json, description: "Success")
                    
                    PushKConstants.logger.debug("\(procedure_name) response jsonData is \(String(describing: jsonData))")
                    
                    PushKConstants.logger.debug("\(procedure_name) response code is \(httpResponse.statusCode)")
                    
                    PushKConstants.logger.debug("\(procedure_name) response data is \(String(describing: data))")
                    
                    PushKConstants.logger.debug("\(procedure_name) response debugDescription is \(httpResponse.debugDescription)")
                    PushKConstants.logger.debug(httpResponse.statusCode)
                    PushKConstants.logger.debug(jsonData as Any)
                    
                    switch (httpResponse.statusCode)
                    {
                    case 200:
                        
                        let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                        
                        
                        if response == "SUCCESS"
                        {
                            PushKConstants.logger.debug("\(procedure_name) success response body is \(String(describing: response))")                }
                        
                    case 401:
                        PushKConstants.registrationstatus = false
                        UserDefaults.standard.set(false, forKey: "registrationstatus")
                        UserDefaults.standard.synchronize()
                        
                    default:
                        PushKConstants.logger.debug("\(procedure_name) save profile POST request got response \(httpResponse.statusCode)")
                    }
                    semaphore3.signal()
                }
                dataTask.resume()
                semaphore3.wait()
                return answ
            } else {
                return self.answer_buider.general_answer_struct(resp_code: "700", body_json: "{\"error\":\"Incorrect input\"}", description: "Failed")
            }
        
    }
    
    //6 procedure
    //for message callback to push server
    func push_message_callback(message_Id: String, answer: String, X_Push_Session_Id: String, X_Push_Auth_Token:String)->PushKGeneralAnswerStruct {
            let procedure_name = "push_message_callback"
            let configuration = URLSessionConfiguration .default
            let session = URLSession(configuration: configuration)
            let semaphore2 = DispatchSemaphore(value: 0)
            var answ: PushKGeneralAnswerStruct = PushKGeneralAnswerStruct.init(code: 0, result: "unknown", description: "unknown", body: "unknown")
            let params =  [
                "messageId": message_Id,
                "answer": answer
                ] as Dictionary<String, AnyObject>
        let urlString = NSString(format: PushKConstants.platform_branch_active.url_Http_Mess_callback as NSString);
            PushKConstants.logger.debug("\(procedure_name) url string is \(urlString)")
            PushKConstants.logger.debug("\(procedure_name) params is \(params.description)")
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = URL(string: NSString(format: "%@", urlString)as String)
            request.httpMethod = "POST"
            request.timeoutInterval = 30
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            //request.addValue("test", forHTTPHeaderField: "X-Hyber-Client-API-Key")
            request.addValue(X_Push_Session_Id, forHTTPHeaderField: "X-Hyber-Session-Id")
            //request.addValue("1234567890", forHTTPHeaderField: "X-Hyber-IOS-Bundle-Id")
            //request.addValue("1", forHTTPHeaderField: "X-Hyber-App-Fingerprint")
            
            
            let timeInterval =  NSDate().timeIntervalSince1970
            let timet = Int(round(timeInterval) as Double)
            let auth_token = X_Push_Auth_Token + ":" + String(timet)
            let sha256_auth_token = auth_token.sha256()
            print(sha256_auth_token)
            
            PushKConstants.logger.debug("\(procedure_name) request X-Hyber-Timestamp is \(String(timet))")
            request.addValue(String(timet), forHTTPHeaderField: "X-Hyber-Timestamp")
            request.addValue(sha256_auth_token, forHTTPHeaderField: "X-Hyber-Auth-Token")
            PushKConstants.logger.debug(request.allHTTPHeaderFields as Any)
            PushKConstants.logger.debug(request.httpBody as Any)
            
            
        do {
            request.httpBody  = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            PushKConstants.logger.debug("request.httpBody error")
        }
            
            let dataTask = session.dataTask(with: request as URLRequest)
            {
                ( data: Data?, response: URLResponse?, error: Error?) -> Void in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        print("error: not a valid http response")
                        semaphore2.signal()
                        return
                }
                
                let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? Dictionary<String, Any>
                let body_json: String = String(decoding: receivedData, as: UTF8.self)
                PushKConstants.logger.debug("push_message_callback body_json from push server: \(body_json)")
                
                answ = self.answer_buider.general_answer_struct(resp_code: String(httpResponse.statusCode), body_json: body_json, description: "Success")
                
                PushKConstants.logger.debug("\(procedure_name) response jsonData is \(String(describing: jsonData))")
                
                PushKConstants.logger.debug("\(procedure_name) response code is \(httpResponse.statusCode)")
                
                PushKConstants.logger.debug("\(procedure_name) response data is \(String(describing: data))")
                
                PushKConstants.logger.debug("\(procedure_name) response debugDescription is \(httpResponse.debugDescription)")
                
                PushKConstants.logger.debug(httpResponse.statusCode)
                
                switch (httpResponse.statusCode)
                {
                case 200:
                    
                    let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                    
                    PushKConstants.logger.debug(jsonData as Any)
                    
                    
                    if response == "SUCCESS"
                    {
                        PushKConstants.logger.debug("\(procedure_name) success response body is \(String(describing: response))")                }
                    
                case 401:
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                default:
                    PushKConstants.logger.debug("\(procedure_name) save profile POST request got response \(httpResponse.statusCode)")
                }
                semaphore2.signal()
            }
            dataTask.resume()
            semaphore2.wait()
            return answ
    }
    
    typealias CompletionHandler = (_ result:NSDictionary) -> Void
    
    func hardProcessingWithString(input: String, completion: (String) -> Void) {
        completion("we finished!")
    }
    
    //7 procedure
    //for get device info from push server
    func push_device_get_all(X_Push_Session_Id: String, X_Push_Auth_Token:String) -> PushKFunAnswerGetDeviceList {
            var answ: PushKFunAnswerGetDeviceList = PushKFunAnswerGetDeviceList.init(code: 0, result: "unknown", description: "unknown", body: nil)
            
            let procedure_name = "push_device_get_all"
            let configuration = URLSessionConfiguration .default
            let session = URLSession(configuration: configuration)
            
            let semaphore = DispatchSemaphore(value: 0)
            
        let urlString = NSString(format: PushKConstants.platform_branch_active.url_Http_Device_getall as NSString);
            PushKConstants.logger.debug("\(procedure_name) url string is \(urlString)")
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = URL(string: NSString(format: "%@", urlString) as String)
            request.httpMethod = "GET"
            request.timeoutInterval = 30
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            //request.addValue("test", forHTTPHeaderField: "X-Hyber-Client-API-Key")
            request.addValue(X_Push_Session_Id, forHTTPHeaderField: "X-Hyber-Session-Id")
            //request.addValue("1234567890", forHTTPHeaderField: "X-Hyber-IOS-Bundle-Id")
            //request.addValue("1", forHTTPHeaderField: "X-Hyber-App-Fingerprint")
            
            
            let timeInterval =  NSDate().timeIntervalSince1970
            let timet = Int(round(timeInterval) as Double)
            
            let auth_token = X_Push_Auth_Token + ":" + String(timet)
            let sha256_auth_token = auth_token.sha256()
            PushKConstants.logger.debug(sha256_auth_token)
            
            PushKConstants.logger.debug("\(procedure_name) request X-Hyber-Timestamp is \(String(timet))")
            request.addValue(String(timet), forHTTPHeaderField: "X-Hyber-Timestamp")
            request.addValue(sha256_auth_token, forHTTPHeaderField: "X-Hyber-Auth-Token")
            
            PushKConstants.logger.debug(request.allHTTPHeaderFields as Any)
            PushKConstants.logger.debug(request.httpBody as Any)
            
            
    
            let dataTask = session.dataTask(with: request as URLRequest)
            {
                ( data: Data?, response: URLResponse?, error: Error?) -> Void in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        print("error: not a valid http response")
                        semaphore.signal()
                        return
                }
                
                let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? Dictionary<String, Any>
                let body_json: String = String(decoding: receivedData, as: UTF8.self)
                PushKConstants.logger.debug("push_device_get_all body_json from push server: \(body_json)")
                
                answ.code = httpResponse.statusCode
                answ.description = "Success"
                answ.result = "Ok"
                answ.body = self.jsonparser.getDeviceListJson(str_resp: body_json)
                
                
                if let userInfo = jsonData as NSDictionary? {
                    let test = userInfo["devices"]
                    
                    if let userInfo2 = test as? NSDictionary {
                        let test2 = userInfo2
                        print(test2)
                    }
                }
                
   
                PushKConstants.logger.debug("\(procedure_name) response code is \(httpResponse.statusCode)")
                
                PushKConstants.logger.debug("\(procedure_name) response data is \(String(describing: data))")
                
                PushKConstants.logger.debug("\(procedure_name) response debugDescription is \(httpResponse.debugDescription)")
                
                switch (httpResponse.statusCode)
                {
                case 200:
                    
                    let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                    
                    
                    
                    
                    
                    if response == "SUCCESS"
                    {
                        PushKConstants.logger.debug("\(procedure_name) success response body is \(String(describing: response))")
                    }
                    
                case 401:
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                    
                    
                default:
                    PushKConstants.logger.debug("\(procedure_name) save profile POST request got response \(httpResponse.statusCode)")
                    
                }
                semaphore.signal()
            }
            dataTask.resume()
            semaphore.wait()
            
            
            print(answ)
            
            return answ
    }
    
    
    func deliveryReport(list: [String], X_Push_Session_Id: String, X_Push_Auth_Token: String,queue_answer: String) {
        
        if (list == [] )
        {
        }else {
            for i in list
            {
                //var messs = queue_answer as! [String: AnyObject]
                
                let messs2 = ["message": queue_answer as AnyObject] as [String: AnyObject]
                
                NotificationCenter.default.post(name: .didReceiveData, object: nil, userInfo: messs2 )
                let res_dr = push_message_dr(message_Id: i, received_At: "123123122341", X_Push_Session_Id: X_Push_Session_Id, X_Push_Auth_Token: X_Push_Auth_Token)
                PushKConstants.logger.debug(res_dr)
            }
            PushKConstants.logger.debug(list)
        }
    }
    
    
    func messidParse(queue_answer: String, X_Push_Session_Id: String, X_Push_Auth_Token: String)->[String] {
        var listdev: [String] = []
        
        let string1 = self.processor.matches(for: "\"messageId\": \"(\\S+-\\S+-\\S+-\\S+-\\S+)\"", in: queue_answer)
        PushKConstants.logger.debug(string1)
        
        /*
         let jsonData2 = try? JSONSerialization.data(withJSONObject: string1, options: [])
         let jsonString2 = String(data: jsonData2!, encoding: .utf8)!
         let string2 = String(jsonString2).replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
         print(string2)
         */
        
        for jj in string1
        {
            PushKConstants.logger.debug(jj)
            let new2String = jj.replacingOccurrences(of: "\"messageId\": ", with: "", options: .literal, range: nil)
            PushKConstants.logger.debug(new2String)
            let new3String = new2String.replacingOccurrences(of: "\"", with: "", options: .literal, range: nil)
            PushKConstants.logger.debug(new3String)
            listdev.append(new3String)
        }
        
        PushKConstants.logger.debug(listdev)
        
        deliveryReport(list: listdev, X_Push_Session_Id: X_Push_Session_Id, X_Push_Auth_Token: X_Push_Auth_Token, queue_answer: queue_answer)
        
        return listdev
    }
    
    //8 queue procedure
    func push_check_queue(X_Push_Session_Id: String, X_Push_Auth_Token:String)->PushKFunAnswerGeneral {
            let procedure_name = "push_check_queue"
            let configuration = URLSessionConfiguration .default
            let session = URLSession(configuration: configuration)
            let semaphore2 = DispatchSemaphore(value: 0)
            var answ: PushKFunAnswerGeneral?
            let params =  [:] as Dictionary<String, AnyObject>
        let urlString = NSString(format: PushKConstants.platform_branch_active.push_url_mess_queue as NSString);
            PushKConstants.logger.debug("\(procedure_name) url string is \(urlString)")
            PushKConstants.logger.debug("\(procedure_name) params is \(params.description)")
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = URL(string: NSString(format: "%@", urlString)as String)
            request.httpMethod = "POST"
            request.timeoutInterval = 30
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            //request.addValue("test", forHTTPHeaderField: "X-Hyber-Client-API-Key")
            request.addValue(X_Push_Session_Id, forHTTPHeaderField: "X-Hyber-Session-Id")
            //request.addValue("1234567890", forHTTPHeaderField: "X-Hyber-IOS-Bundle-Id")
            //request.addValue("1", forHTTPHeaderField: "X-Hyber-App-Fingerprint")
            
            
            let timeInterval =  NSDate().timeIntervalSince1970
            let timet = Int(round(timeInterval) as Double)
            let auth_token = X_Push_Auth_Token + ":" + String(timet)
            let sha256_auth_token = auth_token.sha256()
            PushKConstants.logger.debug(sha256_auth_token)
            
            self.processor.file_logger(message: "\(procedure_name) request X-Hyber-Timestamp is \(String(timet))", loglevel: ".debug")
            request.addValue(String(timet), forHTTPHeaderField: "X-Hyber-Timestamp")
            request.addValue(sha256_auth_token, forHTTPHeaderField: "X-Hyber-Auth-Token")
            PushKConstants.logger.debug(request.allHTTPHeaderFields as Any)
            PushKConstants.logger.debug(request.httpBody as Any)
            
            
        do {
            request.httpBody  = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            PushKConstants.logger.debug("request.httpBody error")
        }
        
            let dataTask = session.dataTask(with: request as URLRequest)
            {
                ( data: Data?, response: URLResponse?, error: Error?) -> Void in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        PushKConstants.logger.error("error: not a valid http response")
                        semaphore2.signal()
                        return
                }
                
                let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? Dictionary<String, Any>
                let body_json: String = String(decoding: receivedData, as: UTF8.self)
                PushKConstants.logger.debug("push_device_get_all body_json from push server: \(body_json)")
                
                answ = self.answer_buider.general_answer2(resp_code: httpResponse.statusCode, body_json: body_json, description: "Success")
                
                PushKConstants.logger.debug("\(procedure_name) response jsonData is \(String(describing: jsonData))")
                PushKConstants.logger.debug("\(procedure_name) response code is \(httpResponse.statusCode)")
                PushKConstants.logger.debug("\(procedure_name) response data is \(String(describing: data))")
                PushKConstants.logger.debug("\(procedure_name) response debugDescription is \(httpResponse.debugDescription)")
                
                PushKConstants.logger.debug(httpResponse.statusCode)
                
                switch (httpResponse.statusCode)
                {
                case 200:
                    
                    let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                    
                    
                    
                    PushKConstants.logger.debug(jsonData as Any)
                    
                    let dataa = String(response ?? "")
                    
                    
                    PushKConstants.logger.debug(self.messidParse(queue_answer: dataa, X_Push_Session_Id: X_Push_Session_Id, X_Push_Auth_Token: X_Push_Auth_Token))
                    
                    
                    if response == "SUCCESS"
                    {
                        PushKConstants.logger.debug("\(procedure_name) success response body is \(String(describing: response))")
                        
                    }
                    
                case 401:
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                default:
                    PushKConstants.logger.debug("\(procedure_name) save profile POST request got response \(httpResponse.statusCode)")
                }
                semaphore2.signal()
            }
            dataTask.resume()
            semaphore2.wait()
        return answ ?? PushKFunAnswerGeneral(code: 710, result: "Unknown error", description: "Nullable statement", body: "{}")
    }
}
