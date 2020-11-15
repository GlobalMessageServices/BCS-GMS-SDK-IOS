//
//  parser.swift
//  PushSDK
//
//  Created by Kirill Kotov on 09/01/2020.
//  Copyright © 2020 PUSHER. All rights reserved.
//

import Foundation


class PusherKParser {
    
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
    
}
