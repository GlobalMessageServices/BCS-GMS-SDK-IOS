//
//  DataSaver.swift
//  GMSPushSDKIOS
//
//  Created by o.korniienko on 22.08.22.
//

import Foundation

internal class PushKDatabase {
    internal func saveDataAfterRegisterOk(userPhone: String,
                                     token: String,
                                     deviceId: String,
                                     userPassword: String,
                                     createdAt: String,
                                     userId: String
        ) {
        UserDefaults.standard.set(userPhone, forKey: "push_user_msisdn")
        PushKConstants.pushUserMsisdn = userPhone
        
        UserDefaults.standard.set(token, forKey: "push_registration_token")
        PushKConstants.pushRegistratioToken = token
        
        UserDefaults.standard.set(true, forKey: "registrationstatus")
        PushKConstants.registrationstatus = true
        
        UserDefaults.standard.set(deviceId, forKey: "deviceId")
        PushKConstants.deviceId = deviceId
        
        UserDefaults.standard.set(userId, forKey: "userId")
        PushKConstants.userId = userId
        
        UserDefaults.standard.set(createdAt, forKey: "created_at")
        PushKConstants.createdAt = createdAt
        
        UserDefaults.standard.set(userPassword, forKey: "push_user_password")
        PushKConstants.pushUserPassword = userPassword
        
        UserDefaults.standard.synchronize()
    }
}
