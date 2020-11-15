//
//  parser.swift
//  PushSDK
//
//  Created by Kirill Kotov on 09/01/2020.
//  Copyright © 2020 PUSHER. All rights reserved.
//

import Foundation


class PusherKParser {
    
    let processor = PushKProcessing.init()
    
    func urls_initialization(branchUrl: String, method_paths: PushSdkParametersPublic.BranchStructObj) {
        if (branchUrl.last == "/")
        {
            PushKConstants.platform_branch_active = PushSdkParametersPublic.BranchStructObj(
                url_Http_Update: branchUrl + method_paths.url_Http_Update,
                url_Http_Registration: branchUrl + method_paths.url_Http_Registration,
                url_Http_Revoke: branchUrl + method_paths.url_Http_Revoke,
                url_Http_Device_getall: branchUrl + method_paths.url_Http_Device_getall,
                url_Http_Mess_callback: branchUrl + method_paths.url_Http_Mess_callback,
                url_Http_Mess_dr: branchUrl + method_paths.url_Http_Mess_dr,
                push_url_mess_queue: branchUrl + method_paths.push_url_mess_queue,
                url_Http_Mess_history: branchUrl + method_paths.url_Http_Mess_history)
        }
        else
        {
            PushKConstants.platform_branch_active = PushSdkParametersPublic.BranchStructObj(
                url_Http_Update: branchUrl + "/" + method_paths.url_Http_Update,
                url_Http_Registration: branchUrl + "/" + method_paths.url_Http_Registration,
                url_Http_Revoke: branchUrl + "/" + method_paths.url_Http_Revoke,
                url_Http_Device_getall: branchUrl + "/" + method_paths.url_Http_Device_getall,
                url_Http_Mess_callback: branchUrl + "/" + method_paths.url_Http_Mess_callback,
                url_Http_Mess_dr: branchUrl + "/" + method_paths.url_Http_Mess_dr,
                push_url_mess_queue: branchUrl + "/" + method_paths.push_url_mess_queue,
                url_Http_Mess_history: branchUrl + "/" + method_paths.url_Http_Mess_history)
        }
    }
    
    func mess_id_parser(message_from_push_server: String) -> String
    {
        
        let newString = message_from_push_server.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        //textOutput.text = newString
        print(newString)
        
        let deviceid_func = self.processor.matches(for: "\"messageId\":\"(.{4,9}-.{3,9}-.{3,9}-.{3,9}-.{4,15})\"", in: newString)
        print(deviceid_func)
        
        let jsonData2 = try? JSONSerialization.data(withJSONObject: deviceid_func, options: [])
        let jsonString2 = String(data: jsonData2!, encoding: .utf8)!
        let new1String = String(jsonString2).replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        print(new1String)
        
        let new2String = new1String.replacingOccurrences(of: "[\"\"messageId\":\"", with: "", options: .literal, range: nil)
        let new3String = new2String.replacingOccurrences(of: "\",\"\"]", with: "", options: .literal, range: nil)
        
        return new3String
    }
    
}
