//
//  DataSaver.swift
//  GMSPushSDKIOS
//
//  Created by o.korniienko on 22.08.22.
//

import Foundation

internal class PushKDatabase {
    internal func saveDataAfterRegisterOk(user_Phone: String,
                                     token: String,
                                     device_id: String,
                                     user_Password: String,
                                     created_at: String,
                                     user_id: String
        ) {
        UserDefaults.standard.set(user_Phone, forKey: "push_user_msisdn")
        PushKConstants.push_user_msisdn = user_Phone
        
        UserDefaults.standard.set(token, forKey: "push_registration_token")
        PushKConstants.push_registration_token = token
        
        UserDefaults.standard.set(true, forKey: "registrationstatus")
        PushKConstants.registrationstatus = true
        
        UserDefaults.standard.set(device_id, forKey: "deviceId")
        PushKConstants.deviceId = device_id
        
        UserDefaults.standard.set(user_id, forKey: "userId")
        PushKConstants.userId = user_id
        
        UserDefaults.standard.set(created_at, forKey: "created_at")
        PushKConstants.created_at = created_at
        
        UserDefaults.standard.set(user_Password, forKey: "push_user_password")
        PushKConstants.push_user_password = user_Password
        
        UserDefaults.standard.synchronize()
    }
}
