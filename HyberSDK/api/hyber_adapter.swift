//
//  hyber_adapter.swift
//  test222
//
//  Created by ard on 16/04/2019.
//  Copyright © 2019 ard. All rights reserved.
//

import Foundation
import CryptoSwift

class HyberAPI {
    
    private let jsonparser = AnswParser.init()
    
    private let processor = Processing.init()
    private let answer_buider = AnswerBuider.init()
    let answer_b = AnswerBuider.init()
    
    //rest function for device registration
    //1 procedure
    func hyber_device_register(X_Hyber_Client_API_Key: String, X_Hyber_Session_Id: String, X_Hyber_IOS_Bundle_Id: String, device_Name:String, device_Type:String, os_Type:String, sdk_Version:String, user_Pass:String, user_Phone:String)-> HyberFunAnswerRegister {
        
        do{
            
            var answ: String = String()
            var genAnsw: HyberFunAnswerRegister = HyberFunAnswerRegister(code: 0, result: "", description: "", deviceId: "", token: "", userId: "", userPhone: "", createdAt: "")
            
            let semaphore7 = DispatchSemaphore(value: 0)
            
            let os_Version = Constants.dev_os_Version
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
            
            let urlString = NSString(format: Constants.url_Http_Registration as NSString);
            processor.file_logger(message: "hyber_device_register url string is \(urlString)", loglevel: ".debug")
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            //var result = "" as? [[String: Any]];
            
            request.url = URL(string: NSString(format: "%@", urlString)as String)
            request.httpMethod = "POST"
            request.timeoutInterval = 30
            
            //headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(X_Hyber_Client_API_Key, forHTTPHeaderField: "X-Hyber-Client-API-Key")
            request.addValue(X_Hyber_Session_Id, forHTTPHeaderField: "X-Hyber-Session-Id")
            request.addValue(X_Hyber_IOS_Bundle_Id, forHTTPHeaderField: "X-Hyber-IOS-Bundle-Id")
            
            request.httpBody  = try! JSONSerialization.data(withJSONObject: params, options: [])
            
            print(request.httpBody)
            print(request.allHTTPHeaderFields)
            
            let dataTask = session.dataTask(with: request as URLRequest)
            {
                ( data: Data?, response: URLResponse?, error: Error?) -> Void in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        print("error: not a valid http response")
                        return
                }
                print(httpResponse)
                
                let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? Dictionary<String, Any>
                //////self.logger.file_logger(message: "\(procedure_name) response jsonData is \(jsonData??["devices"])", loglevel: ".debug")
                let body_json: String = String(decoding: receivedData, as: UTF8.self)
                
                answ = self.answer_buider.general_answer(resp_code: String(httpResponse.statusCode), body_json: body_json, description: "Success")
                
                genAnsw = HyberFunAnswerRegister.init(code: httpResponse.statusCode, result: "unknown", description: "unknown", deviceId: "", token: "", userId: "", userPhone: "", createdAt: "")
                
                
                self.processor.file_logger(message: "hyber_device_register response jsonData is \(jsonData)", loglevel: ".debug")
                
                self.processor.file_logger(message: "hyber_device_register response code is \(httpResponse.statusCode)", loglevel: ".debug")
                
                self.processor.file_logger(message: "hyber_device_register response data is \(data)", loglevel: ".debug")
                
                self.processor.file_logger(message: "hyber_device_register response debugDescription is \(httpResponse.debugDescription)", loglevel: ".debug")
                
                
                
                switch (httpResponse.statusCode)
                {
                case 200:
                    
                    let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                    
                    print("resp dsdfasdf")
                    print(response)
                    
                    let str_resp = response as! String
                    print(str_resp)
                    
                    let resp_register_parsed = self.jsonparser.registerJParse(str_resp: str_resp)
                    
                    UserDefaults.standard.set(resp_register_parsed.deviceId, forKey: "deviceId")
                    Constants.deviceId = resp_register_parsed.deviceId as String?
                    //UserDefaults.standard.synchronize()
                    
                    genAnsw.result = "Success"
                    genAnsw.description = "Procedure completed"
                    genAnsw.createdAt = resp_register_parsed.createdAt
                    genAnsw.deviceId = resp_register_parsed.deviceId
                    genAnsw.token = resp_register_parsed.token
                    genAnsw.userId = String(resp_register_parsed.userId)

                    UserDefaults.standard.set(resp_register_parsed.token, forKey: "hyber_registration_token")
                    Constants.hyber_registration_token = resp_register_parsed.token
                    
                    UserDefaults.standard.set(true, forKey: "registrationstatus")
                    Constants.registrationstatus = true
                    
                    UserDefaults.standard.synchronize()
                    
                    print("regeexp parse")
                    print(resp_register_parsed.token)
                    
                    if response == "SUCCESS"
                    {
                        self.processor.file_logger(message: "hyber_device_register success response body is \(response)", loglevel: ".debug")
                    }
                    
                default:
                    self.processor.file_logger(message: "hyber_device_register save profile POST request got response \(httpResponse.statusCode)", loglevel: ".error")
                }
                //return jsonData
                semaphore7.signal()
            }
            dataTask.resume()
            semaphore7.wait()
            return genAnsw
            
        } catch {
            print("invalid regex: \(error.localizedDescription)")
            return HyberFunAnswerRegister(code: 710, result: "error", description: "Critical error", deviceId: "", token: "", userId: "", userPhone: "", createdAt: "")
        }
        
    }
    
    //2 procedure
    //for revoke device from hyber server
    func hyber_device_revoke(dev_list: [String], X_Hyber_Session_Id: String, X_Hyber_Auth_Token:String)->String {
        do{
            let procedure_name = "hyber_device_revoke"
            let configuration = URLSessionConfiguration .default
            let session = URLSession(configuration: configuration)
            var answ: String = String()
            let semaphore6 = DispatchSemaphore(value: 0)
            
            let params =  ["devices": dev_list] as Dictionary<String, AnyObject>
            let urlString = NSString(format: Constants.url_Http_Revoke);
            
            print("params: \(dev_list)")
            
            processor.file_logger(message: "\(procedure_name) url string is \(urlString)", loglevel: ".debug")
            processor.file_logger(message: "\(procedure_name) params is \"devices\": \(dev_list)", loglevel: ".debug")
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = URL(string: NSString(format: "%@", urlString)as String)
            request.httpMethod = "POST"
            request.timeoutInterval = 30
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.addValue("application/json", forHTTPHeaderField: "Accept")
            //request.addValue("test", forHTTPHeaderField: "X-Hyber-Client-API-Key")
            
            //request.addValue("1234567890", forHTTPHeaderField: "X-Hyber-IOS-Bundle-Id")
            //request.addValue("1", forHTTPHeaderField: "X-Hyber-App-Fingerprint")
            
            
            
            
            let timeInterval =  NSDate().timeIntervalSince1970
            let timet = Int(round(timeInterval) as Double)
            let auth_token = X_Hyber_Auth_Token + ":" + String(timet)
            let sha256_auth_token = auth_token.sha256()
            print(sha256_auth_token)
            
            self.processor.file_logger(message: "\(procedure_name) request X-Hyber-Timestamp is \(String(timet))", loglevel: ".debug")
            request.addValue(String(timet), forHTTPHeaderField: "X-Hyber-Timestamp")
            request.addValue(X_Hyber_Session_Id, forHTTPHeaderField: "X-Hyber-Session-Id")
            request.addValue(sha256_auth_token, forHTTPHeaderField: "X-Hyber-Auth-Token")
            
            print(request.allHTTPHeaderFields)
            print(request.httpBody)
            print(params)
            
            request.httpBody  = try! JSONSerialization.data(withJSONObject: params, options: [])
            
            let dataTask = session.dataTask(with: request as URLRequest)
            {
                ( data: Data?, response: URLResponse?, error: Error?) -> Void in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        print("error: not a valid http response")
                        return
                }
                
                let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? Dictionary<String, Any>
                //////self.logger.file_logger(message: "\(procedure_name) response jsonData is \(jsonData??["devices"])", loglevel: ".debug")
                let body_json: String = String(decoding: receivedData, as: UTF8.self)
                
                
                
                answ = self.answer_buider.general_answer(resp_code: String(httpResponse.statusCode), body_json: body_json, description: "Success")
                
                print(jsonData)
                self.processor.file_logger(message: "\(procedure_name) response jsonData is \(jsonData)", loglevel: ".debug")
                
                self.processor.file_logger(message: "\(procedure_name) response code is \(httpResponse.statusCode)", loglevel: ".debug")
                print(httpResponse.statusCode)
                
                self.processor.file_logger(message: "\(procedure_name) response data is \(data)", loglevel: ".debug")
                
                self.processor.file_logger(message: "\(procedure_name) response debugDescription is \(httpResponse.debugDescription)", loglevel: ".debug")
                
                print(httpResponse.debugDescription)
                
                switch (httpResponse.statusCode)
                {
                case 200:
                    
                    let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                    
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    Constants.registrationstatus = false
                    
                    UserDefaults.standard.synchronize()
                    
                    //if let appDomain = Bundle.main.bundleIdentifier {
                    //    UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    //}
                    
                    
                    if response == "SUCCESS"
                    {
                        self.processor.file_logger(message: "\(procedure_name) success response body is \(response)", loglevel: ".debug")                }
                case 401:
                    Constants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                default:
                    self.processor.file_logger(message: "\(procedure_name) save profile POST request got response \(httpResponse.statusCode)", loglevel: ".error")
                }
                semaphore6.signal()
            }
            dataTask.resume()
           // semaphore6.wait(timeout: DispatchTime.now() + 2)
            semaphore6.wait()
            
            return answ
        } catch {
            print("invalid regex: \(error.localizedDescription)")
            return answer_b.general_answer(resp_code: "710", body_json: "error", description: "Critical error")
        }
    }
    
    
    //3 procedure
    //for update device from hyber server
    func hyber_device_update(fcm_Token: String, os_Type: String, os_Version: String, device_Type: String, device_Name: String, sdk_Version: String, X_Hyber_Session_Id: String, X_Hyber_Auth_Token:String)->String {
        do{
            let procedure_name = "hyber_device_update"
            let configuration = URLSessionConfiguration .default
            let session = URLSession(configuration: configuration)
            var answ: String = String()
            let semaphore5 = DispatchSemaphore(value: 0)
            
            let params =  [
                "fcmToken":fcm_Token,
                "osType":os_Type,
                "osVersion":os_Version,
                "deviceType":device_Type,
                "deviceName":device_Name,
                "sdkVersion":sdk_Version
                ] as Dictionary<String, AnyObject>
            let urlString = NSString(format: Constants.url_Http_Update);
            processor.file_logger(message: "\(procedure_name) url string is \(urlString)", loglevel: ".debug")
            processor.file_logger(message: "\(procedure_name) params is \(params.description)", loglevel: ".debug")
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = URL(string: NSString(format: "%@", urlString)as String)
            request.httpMethod = "POST"
            request.timeoutInterval = 30
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            //request.addValue("test", forHTTPHeaderField: "X-Hyber-Client-API-Key")
            request.addValue(X_Hyber_Session_Id, forHTTPHeaderField: "X-Hyber-Session-Id")
            //request.addValue("1234567890", forHTTPHeaderField: "X-Hyber-IOS-Bundle-Id")
            //request.addValue("1", forHTTPHeaderField: "X-Hyber-App-Fingerprint")
            
            
            let timeInterval =  NSDate().timeIntervalSince1970
            let timet = Int(round(timeInterval) as Double)
            let auth_token = X_Hyber_Auth_Token + ":" + String(timet)
            let sha256_auth_token = auth_token.sha256()
            
            self.processor.file_logger(message: "\(procedure_name) request X-Hyber-Timestamp is \(String(timet))", loglevel: ".debug")
            request.addValue(String(timet), forHTTPHeaderField: "X-Hyber-Timestamp")
            request.addValue(sha256_auth_token, forHTTPHeaderField: "X-Hyber-Auth-Token")
            
            
            
            request.httpBody  = try! JSONSerialization.data(withJSONObject: params, options: [])
            
            print(request.allHTTPHeaderFields)
            print(params)
            
            let dataTask = session.dataTask(with: request as URLRequest)
            {
                ( data: Data?, response: URLResponse?, error: Error?) -> Void in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        print("error: not a valid http response")
                        return
                }
                
                let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? Dictionary<String, Any>
                //////self.logger.file_logger(message: "\(procedure_name) response jsonData is \(jsonData??["devices"])", loglevel: ".debug")
                let body_json: String = String(decoding: receivedData, as: UTF8.self)
                
                let devid_parsed = self.jsonparser.updateregistrationJParse(str_resp: body_json)
                
                answ = self.answer_buider.general_answer(resp_code: String(httpResponse.statusCode), body_json: "deviceId: \(devid_parsed.deviceId)", description: "Success")
                
                self.processor.file_logger(message: "\(procedure_name) response jsonData is \(jsonData)", loglevel: ".debug")
                
                self.processor.file_logger(message: "\(procedure_name) response code is \(httpResponse.statusCode)", loglevel: ".debug")
                
                self.processor.file_logger(message: "\(procedure_name) response data is \(data)", loglevel: ".debug")
                
                self.processor.file_logger(message: "\(procedure_name) response debugDescription is \(httpResponse.debugDescription)", loglevel: ".debug")
                
                print(jsonData)
                print(httpResponse.statusCode)
                
                switch (httpResponse.statusCode)
                {
                case 200:
                    
                    let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                    
                    
                    if response == "SUCCESS"
                    {
                        self.processor.file_logger(message: "\(procedure_name) success response body is \(response)", loglevel: ".debug")                }
                case 401:
                    Constants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                default:
                    self.processor.file_logger(message: "\(procedure_name) save profile POST request got response \(httpResponse.statusCode)", loglevel: ".error")
                }
                semaphore5.signal()
            }
            dataTask.resume()
            semaphore5.wait()
            
            return answ
        } catch {
            print("invalid regex: \(error.localizedDescription)")
            return answer_b.general_answer(resp_code: "710", body_json: "error", description: "Critical error")
        }
    }
    
    
    
    //4 procedure
    //for get message history device from hyber server
    func hyber_message_get_history(utc_time: Int, X_Hyber_Session_Id: String, X_Hyber_Auth_Token:String)->HyberFunAnswerGetMessageHistory {
        do{
            var answ: HyberFunAnswerGetMessageHistory = HyberFunAnswerGetMessageHistory.init(code: 0, result: "unknown", description: "unknown", body: nil)
            let procedure_name = "hyber_message_get_history"
            let configuration = URLSessionConfiguration .default
            let session = URLSession(configuration: configuration)
            let semaphore4 = DispatchSemaphore(value: 0)
            
            let escaped_utc = String(utc_time).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) as! String
            
            let urlString = NSString(format: "\(Constants.url_Http_Mess_history)\(escaped_utc)" as NSString);
            processor.file_logger(message: "\(procedure_name) url string is \(urlString)", loglevel: ".debug")
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = URL(string: NSString(format: "%@", urlString) as String)
            request.httpMethod = "GET"
            request.timeoutInterval = 30
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            //request.addValue("test", forHTTPHeaderField: "X-Hyber-Client-API-Key")
            request.addValue(X_Hyber_Session_Id, forHTTPHeaderField: "X-Hyber-Session-Id")
            //request.addValue("1234567890", forHTTPHeaderField: "X-Hyber-IOS-Bundle-Id")
            //request.addValue("1", forHTTPHeaderField: "X-Hyber-App-Fingerprint")
            
            
            let timeInterval =  NSDate().timeIntervalSince1970
            let timet = Int(round(timeInterval) as Double)
            let auth_token = X_Hyber_Auth_Token + ":" + String(timet)
            let sha256_auth_token = auth_token.sha256()
            
            self.processor.file_logger(message: "\(procedure_name) request X-Hyber-Timestamp is \(String(timet))", loglevel: ".debug")
            request.addValue(String(timet), forHTTPHeaderField: "X-Hyber-Timestamp")
            request.addValue(sha256_auth_token, forHTTPHeaderField: "X-Hyber-Auth-Token")
            
            print(request.allHTTPHeaderFields)
            print(request.httpBody)
            
            //request.httpBody  = try! JSONSerialization.data(withJSONObject: params, options: [])
            
            let dataTask = session.dataTask(with: request as URLRequest)
            {
                ( data: Data?, response: URLResponse?, error: Error?) -> Void in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        print("error: not a valid http response")
                        return
                }
                
                let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? Dictionary<String, Any>
                //////self.logger.file_logger(message: "\(procedure_name) response jsonData is \(jsonData??["devices"])", loglevel: ".debug")
                let body_json: String = String(decoding: receivedData, as: UTF8.self)
                
                answ.code = httpResponse.statusCode
                answ.body = self.jsonparser.getMessageHistoryJson(str_resp: body_json)
                
                //answ = self.answer_buider.general_answer(resp_code: String(httpResponse.statusCode), body_json: body_json, description: "Success")
                
                
                self.processor.file_logger(message: "\(procedure_name) response jsonData is \(jsonData)", loglevel: ".debug")
                
                self.processor.file_logger(message: "\(procedure_name) response code is \(httpResponse.statusCode)", loglevel: ".debug")
                
                self.processor.file_logger(message: "\(procedure_name) response data is \(data)", loglevel: ".debug")
                
                self.processor.file_logger(message: "\(procedure_name) response debugDescription is \(httpResponse.debugDescription)", loglevel: ".debug")
                
                print(jsonData)
                print(httpResponse.statusCode)
                
                switch (httpResponse.statusCode)
                {
                case 200:
                    
                    let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                    
                    answ.result = "Success"
                    
                    
                    if response == "SUCCESS"
                    {
                        self.processor.file_logger(message: "\(procedure_name) success response body is \(response)", loglevel: ".debug")
                    }
                    
                    UserDefaults.standard.set(true, forKey: "registrationstatus")
                    
                case 401:
                    Constants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                    
                default:
                    self.processor.file_logger(message: "\(procedure_name) save profile POST request got response \(httpResponse.statusCode)", loglevel: ".error")
                }
                semaphore4.signal()
            }
            dataTask.resume()
            semaphore4.wait()
            
            return answ
        } catch {
            print("invalid regex: \(error.localizedDescription)")
            
            return HyberFunAnswerGetMessageHistory.init(code: 710, result: "error", description: "Critical error", body: nil)
        }
    }
    
    
    //5 procedure
    //for send delivery report to hyber server
    func hyber_message_dr(message_Id: String, received_At: String, X_Hyber_Session_Id: String, X_Hyber_Auth_Token:String)->String {
        do{
            if (message_Id != nil && message_Id != "" && message_Id != "[]" ) {
                let procedure_name = "hyber_message_dr"
                let configuration = URLSessionConfiguration .default
                let session = URLSession(configuration: configuration)
                var answ: String = String()
                let semaphore3 = DispatchSemaphore(value: 0)
                
                let params =  [
                    "messageId":message_Id
                    //"receivedAt":received_At
                    ] as Dictionary<String, AnyObject>
                let urlString = NSString(format: Constants.url_Http_Mess_dr);
                processor.file_logger(message: "\(procedure_name) url string is \(urlString)", loglevel: ".debug")
                processor.file_logger(message: "\(procedure_name) params is \(params.description)", loglevel: ".debug")
                
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = URL(string: NSString(format: "%@", urlString)as String)
                request.httpMethod = "POST"
                request.timeoutInterval = 30
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                //request.addValue("test", forHTTPHeaderField: "X-Hyber-Client-API-Key")
                request.addValue(X_Hyber_Session_Id, forHTTPHeaderField: "X-Hyber-Session-Id")
                //request.addValue("1234567890", forHTTPHeaderField: "X-Hyber-IOS-Bundle-Id")
                //request.addValue("1", forHTTPHeaderField: "X-Hyber-App-Fingerprint")
                //request.addValue(X_Hyber_Auth_Token, forHTTPHeaderField: "X-Hyber-Auth-Token")
                
                let timeInterval =  NSDate().timeIntervalSince1970
                let timet = Int(round(timeInterval) as Double)
                print("token sfsdfsdfsd")
                print(X_Hyber_Auth_Token)
                print(timet)
                let auth_token = X_Hyber_Auth_Token + ":" + String(timet)
                let sha256_auth_token = auth_token.sha256()
                
                print(sha256_auth_token)
                self.processor.file_logger(message: "\(procedure_name) request X-Hyber-Timestamp is \(String(timet))", loglevel: ".debug")
                
                request.addValue(String(timet), forHTTPHeaderField: "X-Hyber-Timestamp")
                request.addValue(sha256_auth_token, forHTTPHeaderField: "X-Hyber-Auth-Token")
                
                print(request.allHTTPHeaderFields)
                print(request.httpBody)
                
                
                request.httpBody  = try! JSONSerialization.data(withJSONObject: params, options: [])
                
                let dataTask = session.dataTask(with: request as URLRequest)
                {
                    ( data: Data?, response: URLResponse?, error: Error?) -> Void in
                    // 1: Check HTTP Response for successful GET request
                    guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                        else {
                            print("error: not a valid http response")
                            return
                    }
                    
                    let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? Dictionary<String, Any>
                    //////self.logger.file_logger(message: "\(procedure_name) response jsonData is \(jsonData??["devices"])", loglevel: ".debug")
                    let body_json: String = String(decoding: receivedData, as: UTF8.self)
                    
                    answ = self.answer_buider.general_answer(resp_code: String(httpResponse.statusCode), body_json: body_json, description: "Success")
                    
                    self.processor.file_logger(message: "\(procedure_name) response jsonData is \(jsonData)", loglevel: ".debug")
                    
                    self.processor.file_logger(message: "\(procedure_name) response code is \(httpResponse.statusCode)", loglevel: ".debug")
                    
                    self.processor.file_logger(message: "\(procedure_name) response data is \(data)", loglevel: ".debug")
                    
                    self.processor.file_logger(message: "\(procedure_name) response debugDescription is \(httpResponse.debugDescription)", loglevel: ".debug")
                    print(httpResponse.statusCode)
                    print(jsonData)
                    
                    switch (httpResponse.statusCode)
                    {
                    case 200:
                        
                        let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                        
                        
                        if response == "SUCCESS"
                        {
                            self.processor.file_logger(message: "\(procedure_name) success response body is \(response)", loglevel: ".debug")                }
                        
                    case 401:
                        Constants.registrationstatus = false
                        UserDefaults.standard.set(false, forKey: "registrationstatus")
                        UserDefaults.standard.synchronize()
                        
                    default:
                        self.processor.file_logger(message: "\(procedure_name) save profile POST request got response \(httpResponse.statusCode)", loglevel: ".error")
                    }
                    semaphore3.signal()
                }
                dataTask.resume()
                semaphore3.wait()
                return answ
            } else {
                return self.answer_buider.general_answer(resp_code: "700", body_json: "{\"error\":\"Incorrect input\"}", description: "Failed")
            }
            
        } catch {
            print("invalid regex: \(error.localizedDescription)")
            return answer_b.general_answer(resp_code: "710", body_json: "error", description: "Critical error")
        }
        
    }
    
    //6 procedure
    //for message callback to hyber server
    func hyber_message_callback(message_Id: String, answer: String, X_Hyber_Session_Id: String, X_Hyber_Auth_Token:String)->String {
        do {
            let procedure_name = "hyber_message_callback"
            let configuration = URLSessionConfiguration .default
            let session = URLSession(configuration: configuration)
            let semaphore2 = DispatchSemaphore(value: 0)
            var answ: String = String()
            let params =  [
                "messageId":message_Id,
                "answer": answer
                
                ] as Dictionary<String, AnyObject>
            let urlString = NSString(format: Constants.url_Http_Mess_callback);
            processor.file_logger(message: "\(procedure_name) url string is \(urlString)", loglevel: ".debug")
            processor.file_logger(message: "\(procedure_name) params is \(params.description)", loglevel: ".debug")
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = URL(string: NSString(format: "%@", urlString)as String)
            request.httpMethod = "POST"
            request.timeoutInterval = 30
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            //request.addValue("test", forHTTPHeaderField: "X-Hyber-Client-API-Key")
            request.addValue(X_Hyber_Session_Id, forHTTPHeaderField: "X-Hyber-Session-Id")
            //request.addValue("1234567890", forHTTPHeaderField: "X-Hyber-IOS-Bundle-Id")
            //request.addValue("1", forHTTPHeaderField: "X-Hyber-App-Fingerprint")
            
            
            let timeInterval =  NSDate().timeIntervalSince1970
            let timet = Int(round(timeInterval) as Double)
            let auth_token = X_Hyber_Auth_Token + ":" + String(timet)
            let sha256_auth_token = auth_token.sha256()
            print(sha256_auth_token)
            
            self.processor.file_logger(message: "\(procedure_name) request X-Hyber-Timestamp is \(String(timet))", loglevel: ".debug")
            request.addValue(String(timet), forHTTPHeaderField: "X-Hyber-Timestamp")
            request.addValue(sha256_auth_token, forHTTPHeaderField: "X-Hyber-Auth-Token")
            print(request.allHTTPHeaderFields)
            print(request.httpBody)
            
            
            request.httpBody  = try! JSONSerialization.data(withJSONObject: params, options: [])
            
            let dataTask = session.dataTask(with: request as URLRequest)
            {
                ( data: Data?, response: URLResponse?, error: Error?) -> Void in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        print("error: not a valid http response")
                        return
                }
                
                let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? Dictionary<String, Any>
                //////self.logger.file_logger(message: "\(procedure_name) response jsonData is \(jsonData??["devices"])", loglevel: ".debug")
                let body_json: String = String(decoding: receivedData, as: UTF8.self)
                
                answ = self.answer_buider.general_answer(resp_code: String(httpResponse.statusCode), body_json: body_json, description: "Success")
                
                self.processor.file_logger(message: "\(procedure_name) response jsonData is \(jsonData)", loglevel: ".debug")
                
                self.processor.file_logger(message: "\(procedure_name) response code is \(httpResponse.statusCode)", loglevel: ".debug")
                
                self.processor.file_logger(message: "\(procedure_name) response data is \(data)", loglevel: ".debug")
                
                self.processor.file_logger(message: "\(procedure_name) response debugDescription is \(httpResponse.debugDescription)", loglevel: ".debug")
                
                print(httpResponse.statusCode)
                
                switch (httpResponse.statusCode)
                {
                case 200:
                    
                    let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                    
                    print(jsonData)
                    
                    
                    if response == "SUCCESS"
                    {
                        self.processor.file_logger(message: "\(procedure_name) success response body is \(response)", loglevel: ".debug")                }
                    
                case 401:
                    Constants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                default:
                    self.processor.file_logger(message: "\(procedure_name) save profile POST request got response \(httpResponse.statusCode)", loglevel: ".error")
                }
                semaphore2.signal()
            }
            dataTask.resume()
            semaphore2.wait()
            return answ
        } catch {
            print("invalid regex: \(error.localizedDescription)")
            return answer_b.general_answer(resp_code: "710", body_json: "error", description: "Critical error")
        }
    }
    
    typealias CompletionHandler = (_ result:NSDictionary) -> Void
    
    func hardProcessingWithString(input: String, completion: (String) -> Void) {
        completion("we finished!")
    }
    
    //7 procedure
    //for get device info from hyber server
    func hyber_device_get_all(X_Hyber_Session_Id: String, X_Hyber_Auth_Token:String) -> HyberFunAnswerGetDeviceList {
        do{
            var answ: HyberFunAnswerGetDeviceList = HyberFunAnswerGetDeviceList.init(code: 0, result: "unknown", description: "unknown", body: nil)
            
            let procedure_name = "hyber_device_get_all"
            let configuration = URLSessionConfiguration .default
            let session = URLSession(configuration: configuration)
            var dict:NSDictionary!
            
            let semaphore = DispatchSemaphore(value: 0)
            
            let urlString = NSString(format: Constants.url_Http_Device_getall);
            processor.file_logger(message: "\(procedure_name) url string is \(urlString)", loglevel: ".debug")
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = URL(string: NSString(format: "%@", urlString) as String)
            request.httpMethod = "GET"
            request.timeoutInterval = 30
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            //request.addValue("test", forHTTPHeaderField: "X-Hyber-Client-API-Key")
            request.addValue(X_Hyber_Session_Id, forHTTPHeaderField: "X-Hyber-Session-Id")
            //request.addValue("1234567890", forHTTPHeaderField: "X-Hyber-IOS-Bundle-Id")
            //request.addValue("1", forHTTPHeaderField: "X-Hyber-App-Fingerprint")
            
            
            let timeInterval =  NSDate().timeIntervalSince1970
            let timet = Int(round(timeInterval) as Double)
            
            let auth_token = X_Hyber_Auth_Token + ":" + String(timet)
            let sha256_auth_token = auth_token.sha256()
            print(sha256_auth_token)
            
            self.processor.file_logger(message: "\(procedure_name) request X-Hyber-Timestamp is \(String(timet))", loglevel: ".debug")
            request.addValue(String(timet), forHTTPHeaderField: "X-Hyber-Timestamp")
            request.addValue(sha256_auth_token, forHTTPHeaderField: "X-Hyber-Auth-Token")
            
            print(request.allHTTPHeaderFields as Any)
            print(request.httpBody as Any)
            
            
            //request.httpBody  = try! JSONSerialization.data(withJSONObject: params, options: [])
            
            let dataTask = session.dataTask(with: request as URLRequest)
            {
                ( data: Data?, response: URLResponse?, error: Error?) -> Void in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        print("error: not a valid http response")
                        return
                }
                
                let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? Dictionary<String, Any>
                //////self.logger.file_logger(message: "\(procedure_name) response jsonData is \(jsonData??["devices"])", loglevel: ".debug")
                let body_json: String = String(decoding: receivedData, as: UTF8.self)
                
                answ.code = httpResponse.statusCode
                answ.description = "Success"
                answ.result = "Ok"
                answ.body = self.jsonparser.getDeviceListJson(str_resp: body_json)
                

                
                //CompletionHandler(genres: answ)
                
                
                
                
                
                if let userInfo = jsonData as? NSDictionary {
                    let test = userInfo["devices"]
                    
                    if let userInfo2 = test as? NSDictionary {
                        let test2 = userInfo2
                        print(test2)
                    }
                }
                
                //////let requestDataDict:NSDictionary = jsonData!! as NSDictionary
                
                //print(requestDataDict)
                
                //dict = requestDataDict
                
                //print(requestDataDict.object(forKey: "devices"))
                
                
                
                
                self.processor.file_logger(message: "\(procedure_name) response code is \(httpResponse.statusCode)", loglevel: ".debug")
                
                self.processor.file_logger(message: "\(procedure_name) response data is \(data)", loglevel: ".debug")
                
                self.processor.file_logger(message: "\(procedure_name) response debugDescription is \(httpResponse.debugDescription)", loglevel: ".debug")
                
                switch (httpResponse.statusCode)
                {
                case 200:
                    
                    let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                    
                    
                    
                    
                    
                    if response == "SUCCESS"
                    {
                        self.processor.file_logger(message: "\(procedure_name) success response body is \(response)", loglevel: ".debug")                }
                    
                case 401:
                    Constants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                    
                    
                default:
                    self.processor.file_logger(message: "\(procedure_name) save profile POST request got response \(httpResponse.statusCode)", loglevel: ".error")
                    
                }
                semaphore.signal()
            }
            dataTask.resume()
            semaphore.wait()
            
            
            print(answ)
            
            return answ
        } catch {
            print("invalid regex: \(error.localizedDescription)")
            return HyberFunAnswerGetDeviceList.init(code: 710, result: "error", description: "hyber_device_get_all Critical error", body: nil)
        }
    }
    
    
    func deliveryReport(list: [String], X_Hyber_Session_Id: String, X_Hyber_Auth_Token: String,queue_answer: String) {
        
        if (list == [] )
        {
            print("111112222")
        }else {
            for i in list
            {
                //var messs = queue_answer as! [String: AnyObject]
                
                //print(messs)
                
                var messs2 = ["message": queue_answer as AnyObject] as! [String: AnyObject]
                
                NotificationCenter.default.post(name: .didReceiveData, object: nil, userInfo: messs2 )
                hyber_message_dr(message_Id: i, received_At: "123123122341", X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: X_Hyber_Auth_Token)
            }
            print(list)
        }
        
    }
    
    
    func messidParse(queue_answer: String, X_Hyber_Session_Id: String, X_Hyber_Auth_Token: String)->[String] {
        var listdev: [String] = []
        
        var queue_answer2 = "{\"messages\":[{\"phone\": \"375298766719\", \"messageId\": \"cb34da60-c11d-4b1d-a963-5775d3a53a07\", \"title\": \"sd\", \"body\": \"dasdfa\", \"image\": {}, \"button\": {}, \"partner\": \"push\", \"time\": \"2019-11-23T11:11:10.710133+00\"},{\"phone\": \"375298766719\", \"messageId\": \"wfdf-c11d-4b1d-were-5775d3a53a07\", \"title\": \"sd\", \"body\": \"dasdfa\", \"image\": {}, \"button\": {}, \"partner\": \"push\", \"time\": \"2019-11-23T11:11:10.710133+00\"}]}"
        
        
        let string1 = self.processor.matches(for: "\"messageId\": \"(\\S+-\\S+-\\S+-\\S+-\\S+)\"", in: queue_answer)
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
            let new2String = jj.replacingOccurrences(of: "\"messageId\": ", with: "", options: .literal, range: nil)
            print(new2String)
            let new3String = new2String.replacingOccurrences(of: "\"", with: "", options: .literal, range: nil)
            print(new3String)
            
            listdev.append(new3String)
        }
        
        print(listdev)
        
        deliveryReport(list: listdev, X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: X_Hyber_Auth_Token, queue_answer: queue_answer)
        
        if (listdev == [] )
        {
            print("111112222")
        }else {
            print("eeee")
            print(listdev)
        }
        
        return listdev
    }
    
    //8 queue procedure
    func hyber_check_queue(X_Hyber_Session_Id: String, X_Hyber_Auth_Token:String)->HyberFunAnswerGeneral {
        do {
            let procedure_name = "hyber_check_queue"
            let configuration = URLSessionConfiguration .default
            let session = URLSession(configuration: configuration)
            let semaphore2 = DispatchSemaphore(value: 0)
            var answ: HyberFunAnswerGeneral?
            let params =  [:] as Dictionary<String, AnyObject>
            let urlString = NSString(format: Constants.hyber_url_mess_queue);
            processor.file_logger(message: "\(procedure_name) url string is \(urlString)", loglevel: ".debug")
            processor.file_logger(message: "\(procedure_name) params is \(params.description)", loglevel: ".debug")
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = URL(string: NSString(format: "%@", urlString)as String)
            request.httpMethod = "POST"
            request.timeoutInterval = 30
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            //request.addValue("test", forHTTPHeaderField: "X-Hyber-Client-API-Key")
            request.addValue(X_Hyber_Session_Id, forHTTPHeaderField: "X-Hyber-Session-Id")
            //request.addValue("1234567890", forHTTPHeaderField: "X-Hyber-IOS-Bundle-Id")
            //request.addValue("1", forHTTPHeaderField: "X-Hyber-App-Fingerprint")
            
            
            let timeInterval =  NSDate().timeIntervalSince1970
            let timet = Int(round(timeInterval) as Double)
            let auth_token = X_Hyber_Auth_Token + ":" + String(timet)
            let sha256_auth_token = auth_token.sha256()
            print(sha256_auth_token)
            
            self.processor.file_logger(message: "\(procedure_name) request X-Hyber-Timestamp is \(String(timet))", loglevel: ".debug")
            request.addValue(String(timet), forHTTPHeaderField: "X-Hyber-Timestamp")
            request.addValue(sha256_auth_token, forHTTPHeaderField: "X-Hyber-Auth-Token")
            print(request.allHTTPHeaderFields)
            print(request.httpBody)
            
            
            request.httpBody  = try! JSONSerialization.data(withJSONObject: params, options: [])
            
            let dataTask = session.dataTask(with: request as URLRequest)
            {
                ( data: Data?, response: URLResponse?, error: Error?) -> Void in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        print("error: not a valid http response")
                        return
                }
                
                let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? Dictionary<String, Any>
                //////self.logger.file_logger(message: "\(procedure_name) response jsonData is \(jsonData??["devices"])", loglevel: ".debug")
                let body_json: String = String(decoding: receivedData, as: UTF8.self)
                
                answ = self.answer_buider.general_answer2(resp_code: httpResponse.statusCode, body_json: body_json, description: "Success")
                
                self.processor.file_logger(message: "\(procedure_name) response jsonData is \(jsonData)", loglevel: ".debug")
                
                self.processor.file_logger(message: "\(procedure_name) response code is \(httpResponse.statusCode)", loglevel: ".debug")
                
                self.processor.file_logger(message: "\(procedure_name) response data is \(data)", loglevel: ".debug")
                
                self.processor.file_logger(message: "\(procedure_name) response debugDescription is \(httpResponse.debugDescription)", loglevel: ".debug")
                
                print(httpResponse.statusCode)
                
                switch (httpResponse.statusCode)
                {
                case 200:
                    
                    let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                    
                    
                    
                    print(jsonData)
                    
                    let dataa = response as! String
                    
                    
                    print(self.messidParse(queue_answer: dataa, X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: X_Hyber_Auth_Token))
                    
                    
                    if response == "SUCCESS"
                    {
                        self.processor.file_logger(message: "\(procedure_name) success response body is \(response)", loglevel: ".debug")                }
                    
                case 401:
                    Constants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                default:
                    self.processor.file_logger(message: "\(procedure_name) save profile POST request got response \(httpResponse.statusCode)", loglevel: ".error")
                }
                semaphore2.signal()
            }
            dataTask.resume()
            semaphore2.wait()
            return answ!
        } catch {
            print("invalid regex: \(error.localizedDescription)")
            return answer_b.general_answer2(resp_code: 710, body_json: "error", description: "Critical error")
        }
    }
    
    
    /*
     typealias CompletionHandler = (_ result:NSDictionary) -> Void
     
     func hardProcessingWithString(input: String, completion: (String) -> Void) {
     completion("we finished!")
     }
     */
    
    
}
