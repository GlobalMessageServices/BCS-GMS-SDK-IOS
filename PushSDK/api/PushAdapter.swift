//
//  PushAdapter.swift
//  GMSPushSDKIOS
//
//  Created by o.korniienko on 22.08.22.
//

import Foundation
import CryptoSwift
import Alamofire




internal class PushAPI {
    
    private let jsonparser = PushServerAnswParser.init()
    private let push_database_adapter = PushKDatabase.init()
    private let answer_buider = AnswerBuilder.init()
    private let serverDataResponses = DataResponses()
    
    
    
    //function for device registration
    func registerPushDevice(X_Push_Client_API_Key: String, X_Push_Session_Id: String, X_Push_IOS_Bundle_Id: String, device_Name:String, device_Type:String, os_Type:String, sdk_Version:String, user_Pass:String, user_Phone:String) -> PushKFunAnswerRegister {
        
        PushKConstants.logger.debug("Start function registerPushDevice")
        let semaphore = DispatchSemaphore(value: 0)
         
        
        var genAnsw: PushKFunAnswerRegister = PushKFunAnswerRegister(code: 0, result: "", description: "", deviceId: "", token: "", userId: "", userPhone: "", createdAt: "")
         
        let os_Version = PushKConstants.dev_os_Version
        
        let requestURL = PushKConstants.platform_branch_active.url_Http_Registration
        PushKConstants.logger.debug("registerPushDevice url string is \(requestURL)")
         
        let params: Parameters = [
            "deviceName": device_Name,
            "deviceType": device_Type,
            "osType": os_Type,
            "osVersion": os_Version,
            "sdkVersion": sdk_Version,
            "userPass": user_Pass,
            "userPhone": user_Phone
        ]
                 
        let headersRequest: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Hyber-Session-Id": X_Push_Session_Id,
            "X-Hyber-Client-API-Key": X_Push_Client_API_Key,
            "X-Hyber-IOS-Bundle-Id": X_Push_IOS_Bundle_Id
        ]
        
        PushKConstants.logger.debug(params)
        PushKConstants.logger.debug(headersRequest)
        
        
        Task{
            serverDataResponses.reristerResponse = await makePostRequest(headersRequest: headersRequest, params: params, url: requestURL)
            semaphore.signal()
        }
        semaphore.wait()
        
        let response = serverDataResponses.reristerResponse
        PushKConstants.logger.debug("registerPushDevice response is \(String(describing: response))")
        genAnsw.code = response?.response?.statusCode ?? 500
        
        if response != nil && response?.error == nil{
            PushKConstants.logger.debug("registerPushDevice response debugDescription is \(String(describing: response?.debugDescription))")

        
            switch response?.response?.statusCode {
                case 200:
                    PushKConstants.logger.debug("registerPushDevice response data is \(String(describing: response?.data))")
                    let responseNSString = NSString (data: (response?.data)! , encoding:      String.Encoding.utf8.rawValue)
        
                    PushKConstants.logger.debug(String(responseNSString ?? ""))
                    let respStr = String(responseNSString ?? "")
                    PushKConstants.logger.debug(respStr)
                    let parsedRegisterResp = self.jsonparser.registerJParse(str_resp: respStr)
        
                    genAnsw.result = "Success"
                    genAnsw.description = "Procedure completed"
                    genAnsw.createdAt = parsedRegisterResp.createdAt ??  "empty"
                    genAnsw.deviceId = parsedRegisterResp.deviceId ?? "unknown"
                    genAnsw.token = parsedRegisterResp.token ?? "empty_token"
                    genAnsw.userId = String(parsedRegisterResp.userId ?? 0)
        
                    self.push_database_adapter.saveDataAfterRegisterOk(
                        user_Phone: user_Phone,
                        token: parsedRegisterResp.token ?? "empty_token",
                        device_id: parsedRegisterResp.deviceId ?? "unknown",
                        user_Password: user_Pass,
                        created_at: parsedRegisterResp.createdAt ??  "empty",
                        user_id: String(parsedRegisterResp.userId ?? 0)
                    )
        
                    PushKConstants.logger.debug(parsedRegisterResp.token ?? "")
                    PushKConstants.logger.debug("registerPushDevice response code is \(String(describing: response?.response!.statusCode))")
        
                default:
                    PushKConstants.logger.debug("registerPushDevice response code is \(String(describing: response?.response!.statusCode))")
        
        
            }
            
        }
                    
        
        return genAnsw
        
    }
    
    //update device registration on push server
    func pushUpdateRegistration(fcm_Token: String, os_Type: String, os_Version: String, device_Type: String, device_Name: String, sdk_Version: String, X_Push_Session_Id: String, X_Push_Auth_Token:String) -> PushKGeneralAnswerStruct {
        PushKConstants.logger.debug("Start function pushUpdateRegistration")
        let semaphore = DispatchSemaphore(value: 0)
         
        
        var genAnsw: PushKGeneralAnswerStruct = PushKGeneralAnswerStruct.init(code: 0, result: "unknown", description: "unknown", body: "unknown")
        
        let requestURL = PushKConstants.platform_branch_active.url_Http_Update
        PushKConstants.logger.debug("pushUpdateRegistration url string is \(requestURL)")
        
        
        let timeInterval =  NSDate().timeIntervalSince1970
        let timet = Int(round(timeInterval) as Double)
        PushKConstants.logger.debug("pushUpdateRegistration request X-Hyber-Timestamp is \(String(timet))")
        
        let auth_token = X_Push_Auth_Token + ":" + String(timet)
        let sha256_auth_token = auth_token.sha256()
        PushKConstants.logger.debug(sha256_auth_token)
        
        let params =  [
            "fcmToken": fcm_Token,
            "osType": os_Type,
            "osVersion": os_Version,
            "deviceType": device_Type,
            "deviceName": device_Name,
            "sdkVersion": sdk_Version
            ] as Dictionary<String, AnyObject>
        
        let headersRequest: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-Hyber-Session-Id": X_Push_Session_Id,
            "X-Hyber-Timestamp": String(timet),
            "X-Hyber-Auth-Token": sha256_auth_token
        ]
        
        PushKConstants.logger.debug(params)
        PushKConstants.logger.debug(headersRequest)
        
        Task{
            serverDataResponses.updateResponse = await makePostRequest(headersRequest: headersRequest, params: params, url: requestURL)
            semaphore.signal()
        }
        semaphore.wait()
        
        let response = serverDataResponses.updateResponse
        PushKConstants.logger.debug("pushUpdateRegistration response is \(String(describing: response))")
        genAnsw.code = response?.response?.statusCode ?? 500
        
        if response != nil && response?.error == nil{
            
            PushKConstants.logger.debug("pushUpdateRegistration response debugDescription is \(String(describing: response?.debugDescription))")
            PushKConstants.logger.debug("pushUpdateRegistration response data is \(String(describing: response?.data))")
            let body_json: String = String(decoding: (response?.data)!, as: UTF8.self)
            PushKConstants.logger.debug("pushUpdateRegistration body_json from push server: \(body_json)")
    
            let devis_parsed = self.jsonparser.updateregistrationJParse(str_resp: body_json)
            genAnsw = self.answer_buider.generalAnswerStruct(resp_code: response?.response!.statusCode ?? 0, body_json: "deviceId: \(devis_parsed.deviceId)", description: "Success")
            
            switch response?.response?.statusCode {
                case 401:
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.synchronize()
                    PushKConstants.logger.debug("pushUpdateRegistration response code is \(String(describing: response?.response!.statusCode))")
                default:
                    PushKConstants.logger.debug("pushUpdateRegistration response code is \(String(describing: response?.response!.statusCode))")
        
        
            }
            
        }
        
        return genAnsw
    }
    
    //remove devices from push server
    func pushDeviceRevoke(dev_list: [String], X_Push_Session_Id: String, X_Push_Auth_Token:String)->PushKGeneralAnswerStruct {
        PushKConstants.logger.debug("Start function pushDeviceRevoke")
        let semaphore = DispatchSemaphore(value: 0)
         
        
        
        var genAnsw: PushKGeneralAnswerStruct = PushKGeneralAnswerStruct.init(code: 0, result: "unknown", description: "unknown", body: "unknown")
        
        let requestURL = PushKConstants.platform_branch_active.url_Http_Revoke
        PushKConstants.logger.debug("pushDeviceRevoke url string is \(requestURL)")
        
        
        let timeInterval =  NSDate().timeIntervalSince1970
        let timet = Int(round(timeInterval) as Double)
        PushKConstants.logger.debug("pushDeviceRevoke request X-Hyber-Timestamp is \(String(timet))")
        
        let auth_token = X_Push_Auth_Token + ":" + String(timet)
        let sha256_auth_token = auth_token.sha256()
        PushKConstants.logger.debug(sha256_auth_token)
        
        let params = ["devices": dev_list] as Dictionary<String, AnyObject>
        
        let headersRequest: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Hyber-Session-Id": X_Push_Session_Id,
            "X-Hyber-Timestamp": String(timet),
            "X-Hyber-Auth-Token": sha256_auth_token
        ]
        PushKConstants.logger.debug(params)
        PushKConstants.logger.debug(headersRequest)
        
        Task{
            serverDataResponses.revokeDeviceResponse = await makePostRequest(headersRequest: headersRequest, params: params, url: requestURL)
            semaphore.signal()
        }
        semaphore.wait()
        
        let response = serverDataResponses.revokeDeviceResponse
        PushKConstants.logger.debug("pushDeviceRevoke response is \(String(describing: response))")
        genAnsw.code = response?.response?.statusCode ?? 500
        
        if response != nil && response?.error == nil{
            PushKConstants.logger.debug("pushDeviceRevoke response data is \(String(describing:response?.data))")
        
            let body_json: String = String(decoding: (response?.data)!, as: UTF8.self)
    
            PushKConstants.logger.debug("pushDeviceRevoke body_json from push server: \(body_json)")
    
            genAnsw = self.answer_buider.generalAnswerStruct(resp_code: response?.response!.statusCode ?? 0, body_json: body_json, description: "Success")
    
            PushKConstants.logger.debug("pushDeviceRevoke response debugDescription is \(response.debugDescription)")
        
            switch response?.response?.statusCode {
                case 200, 401:
        
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.synchronize()
                    PushKConstants.logger.debug("pushDeviceRevoke response code is \(String(describing: response?.response!.statusCode))")
                default:
                    PushKConstants.logger.debug("pushDeviceRevoke response code is \(String(describing: response?.response!.statusCode))")
        
        
            }
            
        }
                    
        return genAnsw
    }
    
    
    //get devices info from push server
    func pushDevicesGetAll(X_Push_Session_Id: String, X_Push_Auth_Token:String) -> PushKFunAnswerGetDeviceList{
        PushKConstants.logger.debug("Start function pushDevicesGetAll")
        let semaphore = DispatchSemaphore(value: 0)
         
        
        var genAnsw: PushKFunAnswerGetDeviceList = PushKFunAnswerGetDeviceList(code: 0, result: "", description: "", body: nil)
        
        let requestURL = PushKConstants.platform_branch_active.url_Http_Device_getall
        PushKConstants.logger.debug("pushDevicesGetAll url string is \(requestURL)")
        
        
        let timeInterval =  NSDate().timeIntervalSince1970
        let timet = Int(round(timeInterval) as Double)
        PushKConstants.logger.debug("pushDevicesGetAll request X-Hyber-Timestamp is \(String(timet))")
        
        let auth_token = X_Push_Auth_Token + ":" + String(timet)
        let sha256_auth_token = auth_token.sha256()
        PushKConstants.logger.debug(sha256_auth_token)
        
        let headersRequest: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-Hyber-Session-Id": X_Push_Session_Id,
            "X-Hyber-Timestamp": String(timet),
            "X-Hyber-Auth-Token": sha256_auth_token
        ]
        PushKConstants.logger.debug(headersRequest)
        
        
        Task{
            serverDataResponses.getAllDevicesResponse = await makeGetRequest(headersRequest: headersRequest, url: requestURL)
            semaphore.signal()
        }
        semaphore.wait()
        
        let response = serverDataResponses.getAllDevicesResponse
        PushKConstants.logger.debug("pushDevicesGetAll response is \(String(describing: response))")
        genAnsw.code = response?.response?.statusCode ?? 500
        
        if response != nil && response?.error == nil{
            PushKConstants.logger.debug("pushDevicesGetAll response jsonData is \(String(describing:     response?.debugDescription))")
            PushKConstants.logger.debug("pusGetMessageHistory response data is \(String(describing: response?.data))")
        
            switch response?.response?.statusCode {
                case 200:
        
                    let body_json: String = String(decoding: (response?.data)!, as: UTF8.self)
                    PushKConstants.logger.debug("pushDevicesGetAll body_json from push server: \(body_json)")
        
        
                    genAnsw.description = "Success"
                    genAnsw.result = "Ok"
                    genAnsw.body = self.jsonparser.getDeviceListJson(str_resp: body_json)
                    PushKConstants.logger.debug("pushDevicesGetAll response code is \(String(describing: response?.response!.statusCode))")
        
                case 401:
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    PushKConstants.logger.debug("pushDevicesGetAll response code is \(String(describing: response?.response!.statusCode))")
        
                default:
                    PushKConstants.logger.debug("pushDevicesGetAll response code is \(String(describing: response?.response!.statusCode))")
        
        
            }
            
        }
                    
        
        return genAnsw
        
    }
    
    
    //get message history for device from push server
    func pushGetMessageHistory(utc_time: Int, X_Push_Session_Id: String, X_Push_Auth_Token:String)->PushKFunAnswerGetMessageHistory {
        
        PushKConstants.logger.debug("Start function pushGetMessageHistory")
        let semaphore = DispatchSemaphore(value: 0)
         
        var genAnsw: PushKFunAnswerGetMessageHistory = PushKFunAnswerGetMessageHistory.init(code: 0, result: "unknown", description: "unknown", body: nil)
        
        let timeInterval =  NSDate().timeIntervalSince1970
        let timet = Int(round(timeInterval) as Double)
        PushKConstants.logger.debug("pushGetMessageHistory request X-Hyber-Timestamp is \(String(timet))")
        
        let timestampForServerUrl = timet - utc_time
        
        let requestURL = String(format: "\(PushKConstants.platform_branch_active.url_Http_Mess_history)\(String(timestampForServerUrl))")
        PushKConstants.logger.debug("pushGetMessageHistory url string is \(requestURL)")
        
        let auth_token = X_Push_Auth_Token + ":" + String(timet)
        let sha256_auth_token = auth_token.sha256()
        PushKConstants.logger.debug(sha256_auth_token)
        
        let headersRequest: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-Hyber-Session-Id": X_Push_Session_Id,
            "X-Hyber-Timestamp": String(timet),
            "X-Hyber-Auth-Token": sha256_auth_token
        ]
        PushKConstants.logger.debug(headersRequest)
        
        Task{
            serverDataResponses.getAllDevicesResponse = await makeGetRequest(headersRequest: headersRequest, url: requestURL)
            semaphore.signal()
        }
        semaphore.wait()
        
        let response = serverDataResponses.getAllDevicesResponse
        PushKConstants.logger.debug("pushGetMessageHistory response is \(String(describing: response))")
        genAnsw.code = response?.response?.statusCode ?? 500
    
        if response != nil && response?.error == nil{
            
            PushKConstants.logger.debug("pushGetMessageHistory response data is \(String(describing: response?.data))")
            
            PushKConstants.logger.debug("pushGetMessageHistory response debugDescription is \(String(describing: response?.debugDescription))")
            
            switch response?.response?.statusCode {
                case 200:
                    
                    let body_json: String = String(decoding: (response?.data)!, as: UTF8.self)
                    PushKConstants.logger.debug("pusGetMessageHistory body_json from push server: \(body_json)")
                    genAnsw.description = "Success"
                    genAnsw.result = "Ok"
                    genAnsw.body = self.jsonparser.getMessageHistoryJson(str_resp: body_json)
                    
                    PushKConstants.logger.debug("pushGetMessageHistory response code is \(String(describing: response?.response!.statusCode))")
                
                case 401:
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                    PushKConstants.logger.debug("pushGetMessageHistory response code is \(String(describing: response?.response!.statusCode))")
                default:
                    PushKConstants.logger.debug("pushGetMessageHistory response code is \(String(describing: response?.response!.statusCode))")
            }
        }
        
        
        return genAnsw
        
    }
    
    
    //check queue
    func checkQueue(X_Push_Session_Id: String, X_Push_Auth_Token:String)->PushKFunAnswerGeneral {
        
        var genAnsw: PushKFunAnswerGeneral = PushKFunAnswerGeneral(code: 0, result: "unknown", description: "unknown", body: "{}")
        
        
        let requestURL = PushKConstants.platform_branch_active.push_url_mess_queue
        PushKConstants.logger.debug("checkQueue url string is \(requestURL)")
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let timeInterval =  NSDate().timeIntervalSince1970
        let timet = Int(round(timeInterval) as Double)
        PushKConstants.logger.debug("checkQueue request X-Hyber-Timestamp is \(String(timet))")
        
        let auth_token = X_Push_Auth_Token + ":" + String(timet)
        let sha256_auth_token = auth_token.sha256()
        PushKConstants.logger.debug(sha256_auth_token)
        
        let params =  [:] as Dictionary<String, AnyObject>
        let headersRequest: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-Hyber-Session-Id": X_Push_Session_Id,
            "X-Hyber-Timestamp": String(timet),
            "X-Hyber-Auth-Token": sha256_auth_token
        ]
        PushKConstants.logger.debug(params)
        PushKConstants.logger.debug(headersRequest)

        Task{
            serverDataResponses.revokeDeviceResponse = await makePostRequest(headersRequest: headersRequest, params: params, url: requestURL)
            semaphore.signal()
        }
        semaphore.wait()
        
        let response = serverDataResponses.revokeDeviceResponse
        PushKConstants.logger.debug("checkQueue response is \(String(describing: response))")
        genAnsw.code = response?.response?.statusCode ?? 500
        
        if response != nil && response?.error == nil{
            PushKConstants.logger.debug("checkQueue response data is \(String(describing: response?.data))")
            
            PushKConstants.logger.debug("checkQueue response debugDescription is \(String(describing: response?.debugDescription))")
            
            switch response?.response?.statusCode {
                case 200:
                    
                    let body_json: String = String(decoding: (response?.data)!, as: UTF8.self)
                    PushKConstants.logger.debug("checkQueue body_json from push server: \(body_json)")
                
                    genAnsw  = self.answer_buider.generalAnswer(resp_code: response?.response!.statusCode ?? 0, body_json: body_json, description: "Success")
                    
                    PushKConstants.logger.debug("checkQueue response code is \(String(describing: response?.response!.statusCode))")
                
                
                case 401:
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                    PushKConstants.logger.debug("checkQueue response code is \(String(describing: response?.response!.statusCode))")
                default:
                    PushKConstants.logger.debug("checkQueue response code is \(String(describing: response?.response!.statusCode))")
            }
        }
        
        return genAnsw
    }
    
    
    //send delivery report to push server
    func sendMessageDR(message_Id: String, received_At: String, X_Push_Session_Id: String, X_Push_Auth_Token:String)->PushKGeneralAnswerStruct {
        if (message_Id != "" && message_Id != "[]" ) {
            var genAnsw: PushKGeneralAnswerStruct = PushKGeneralAnswerStruct.init(code: 0, result: "unknown", description: "unknown", body: "unknown")
            
            let requestURL = PushKConstants.platform_branch_active.url_Http_Mess_dr
            PushKConstants.logger.debug("sendMessageDR url string is \(requestURL)")
            
            let semaphore = DispatchSemaphore(value: 0)
            
            let timeInterval =  NSDate().timeIntervalSince1970
            let timet = Int(round(timeInterval) as Double)
            PushKConstants.logger.debug("sendMessageDR request X-Hyber-Timestamp is \(String(timet))")
            
            let auth_token = X_Push_Auth_Token + ":" + String(timet)
            let sha256_auth_token = auth_token.sha256()
            PushKConstants.logger.debug(sha256_auth_token)
            
            let params = ["messageId":message_Id] as Dictionary<String, AnyObject>
            
            let headersRequest: HTTPHeaders = [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "X-Hyber-Session-Id": X_Push_Session_Id,
                "X-Hyber-Timestamp": String(timet),
                "X-Hyber-Auth-Token": sha256_auth_token
            ]
            PushKConstants.logger.debug(params)
            PushKConstants.logger.debug(headersRequest)

            Task{
                serverDataResponses.revokeDeviceResponse = await makePostRequest(headersRequest: headersRequest, params: params, url: requestURL)
                semaphore.signal()
            }
            semaphore.wait()
            
            let response = serverDataResponses.revokeDeviceResponse
            PushKConstants.logger.debug("sendMessageDR response is \(String(describing: response))")
            genAnsw.code = response?.response?.statusCode ?? 500
            
            if response != nil && response?.error == nil{
                PushKConstants.logger.debug("sendMessageDR response data is \(String(describing: response?.data))")
                
                PushKConstants.logger.debug("sendMessageDR response debugDescription is \(String(describing: response?.debugDescription))")
                
                switch response?.response?.statusCode {
                    case 200:
                        
                        let body_json: String = String(decoding: (response?.data)!, as: UTF8.self)
                        PushKConstants.logger.debug("sendMessageDR body_json from push server: \(body_json)")
                    
                        genAnsw = self.answer_buider.generalAnswerStruct(resp_code: response?.response!.statusCode ?? 0, body_json: body_json, description: "Success")
                        
                        PushKConstants.logger.debug("sendMessageDR response code is \(String(describing: response?.response!.statusCode))")
                    
                    case 401:
                        PushKConstants.registrationstatus = false
                        UserDefaults.standard.set(false, forKey: "registrationstatus")
                        UserDefaults.standard.synchronize()
                        
                        PushKConstants.logger.debug("sendMessageDR response code is \(String(describing: response?.response!.statusCode))")
                    default:
                        PushKConstants.logger.debug("sendMessageDR response code is \(String(describing: response?.response!.statusCode))")
                }
            }
            
            return genAnsw
        }else{
            PushKConstants.logger.debug("sendMessageDR message_Id is \(message_Id)")
            return self.answer_buider.generalAnswerStruct(resp_code: 700, body_json: "{\"error\":\"Incorrect input\"}", description: "Failed")
        }
    }
    
    
    //send message callback to push server
    func sendMessageCallBack(message_Id: String, answer: String, X_Push_Session_Id: String, X_Push_Auth_Token:String)->PushKGeneralAnswerStruct {
        
        let semaphore = DispatchSemaphore(value: 0)
        var genAnsw: PushKGeneralAnswerStruct = PushKGeneralAnswerStruct.init(code: 0, result: "unknown", description: "unknown", body: "unknown")
        
        let requestURL = PushKConstants.platform_branch_active.url_Http_Mess_callback
        PushKConstants.logger.debug("sendMessaeCallBack url string is \(requestURL)")
        
        let timeInterval =  NSDate().timeIntervalSince1970
        let timet = Int(round(timeInterval) as Double)
        PushKConstants.logger.debug("sendMessaeCallBack request X-Hyber-Timestamp is \(String(timet))")
        
        let auth_token = X_Push_Auth_Token + ":" + String(timet)
        let sha256_auth_token = auth_token.sha256()
        PushKConstants.logger.debug(sha256_auth_token)
        
        let params =  [
            "messageId": message_Id,
            "answer": answer
        ] as Dictionary<String, AnyObject>
        
        let headersRequest: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-Hyber-Session-Id": X_Push_Session_Id,
            "X-Hyber-Timestamp": String(timet),
            "X-Hyber-Auth-Token": sha256_auth_token
        ]
        PushKConstants.logger.debug(params)
        PushKConstants.logger.debug(headersRequest)

        Task{
            serverDataResponses.revokeDeviceResponse = await makePostRequest(headersRequest: headersRequest, params: params, url: requestURL)
            semaphore.signal()
        }
        semaphore.wait()
        
        let response = serverDataResponses.revokeDeviceResponse
        PushKConstants.logger.debug("sendMessaeCallBack response is \(String(describing: response))")
        genAnsw.code = response?.response?.statusCode ?? 500
        
        if response != nil && response?.error == nil{
            PushKConstants.logger.debug("sendMessaeCallBack response data is \(String(describing: response?.data))")
            
            PushKConstants.logger.debug("sendMessaeCallBack response debugDescription is \(String(describing: response?.debugDescription))")
            
            switch response?.response?.statusCode {
                case 200:
                    
                    let body_json: String = String(decoding: (response?.data)!, as: UTF8.self)
                    PushKConstants.logger.debug("sendMessaeCallBack body_json from push server: \(body_json)")
                
                    genAnsw  = self.answer_buider.generalAnswerStruct(resp_code: response?.response!.statusCode ?? 0, body_json: body_json, description: "Success")
                    
                    PushKConstants.logger.debug("sendMessaeCallBack response code is \(String(describing: response?.response!.statusCode))")
                
                
                case 401:
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                    PushKConstants.logger.debug("sendMessaeCallBack response code is \(String(describing: response?.response!.statusCode))")
                default:
                    PushKConstants.logger.debug("sendMessaeCallBack response code is \(String(describing: response?.response!.statusCode))")
            }
        }
        
        
        return genAnsw
    }
    
    
    
    func makePostRequest(headersRequest: HTTPHeaders, params: Parameters, url: String) async -> DataResponse<String, AFError>{
        let task = AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headersRequest){$0.timeoutInterval = 15}.serializingString()
        let response = await task.response
        //{$0.timeoutInterval = 30}
        return response
        
    }
    
    func makeGetRequest(headersRequest: HTTPHeaders, url: String) async -> DataResponse<String, AFError>{
        let task = AF.request(url, method: .get, encoding:JSONEncoding.default, headers: headersRequest){$0.timeoutInterval = 15}.serializingString()
        let response = await task.response
            
        return response
    }
    
    
}


internal class DataResponses{
    
    var reristerResponse : DataResponse<String, AFError>!
    var getAllDevicesResponse : DataResponse<String, AFError>!
    var revokeDeviceResponse : DataResponse<String, AFError>!
    var updateResponse : DataResponse<String, AFError>!
    
}
