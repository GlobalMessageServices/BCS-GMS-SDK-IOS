//
//  parser.swift
//  PushSDK
//
//  Created by Kirill Kotov on 09/01/2020.
//  Copyright © 2020 PUSHER. All rights reserved.
//

import Foundation


public class PusherKParser {
    
    public init() {}
    
    let processor = PushKProcessing.init()
    
    public func urlsInitialization(branchUrl: String, method_paths: BranchStructObj) {
        if (branchUrl.last == "/")
        {
            PushKConstants.platform_branch_active = BranchStructObj(
                url_Http_Update: branchUrl + PushKConstants.serverSdkVersion + "/" + method_paths.url_Http_Update,
                url_Http_Registration: branchUrl + PushKConstants.serverSdkVersion + "/" + method_paths.url_Http_Registration,
                url_Http_Revoke: branchUrl + PushKConstants.serverSdkVersion + "/" + method_paths.url_Http_Revoke,
                url_Http_Device_getall: branchUrl + PushKConstants.serverSdkVersion + "/" + method_paths.url_Http_Device_getall,
                url_Http_Mess_callback: branchUrl + PushKConstants.serverSdkVersion + "/" + method_paths.url_Http_Mess_callback,
                url_Http_Mess_dr: branchUrl + PushKConstants.serverSdkVersion + "/" + method_paths.url_Http_Mess_dr,
                push_url_mess_queue: branchUrl + PushKConstants.serverSdkVersion + "/" + method_paths.push_url_mess_queue,
                url_Http_Mess_history: branchUrl + PushKConstants.serverSdkVersion + "/" + method_paths.url_Http_Mess_history)
        }
        else
        {
            PushKConstants.platform_branch_active = BranchStructObj(
                url_Http_Update: branchUrl + "/" + PushKConstants.serverSdkVersion + "/" + method_paths.url_Http_Update,
                url_Http_Registration: branchUrl + "/" + PushKConstants.serverSdkVersion + "/" + method_paths.url_Http_Registration,
                url_Http_Revoke: branchUrl + "/" + PushKConstants.serverSdkVersion + "/" + method_paths.url_Http_Revoke,
                url_Http_Device_getall: branchUrl + "/" + PushKConstants.serverSdkVersion + "/" + method_paths.url_Http_Device_getall,
                url_Http_Mess_callback: branchUrl + "/" + PushKConstants.serverSdkVersion + "/" + method_paths.url_Http_Mess_callback,
                url_Http_Mess_dr: branchUrl + "/" + PushKConstants.serverSdkVersion + "/" + method_paths.url_Http_Mess_dr,
                push_url_mess_queue: branchUrl + "/" + PushKConstants.serverSdkVersion + "/" + method_paths.push_url_mess_queue,
                url_Http_Mess_history: branchUrl + "/" + PushKConstants.serverSdkVersion + "/" + method_paths.url_Http_Mess_history)
        }
    }
    
    public func messIdParser(message_from_push_server: String) -> String
    {
        
        let newString = message_from_push_server.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        //textOutput.text = newString
        PushKConstants.logger.debug(newString)
        
        let deviceid_func = self.processor.matches(for: "\"messageId\":\"(.{4,9}-.{3,9}-.{3,9}-.{3,9}-.{4,15})\"", in: newString)
        PushKConstants.logger.debug(deviceid_func)
        
        guard let jsonData2 = try? JSONSerialization.data(withJSONObject: deviceid_func, options: []) else { return "" }
        let jsonString2 = String(data: jsonData2, encoding: .utf8) ?? ""
        let new1String = String(jsonString2).replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        PushKConstants.logger.debug(new1String)
        
        let new2String = new1String.replacingOccurrences(of: "[\"\"messageId\":\"", with: "", options: .literal, range: nil)
        let new3String = new2String.replacingOccurrences(of: "\",\"\"]", with: "", options: .literal, range: nil)
        
        return new3String
    }
    

    
}
