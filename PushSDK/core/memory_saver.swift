//
//  memory_saver.swift
//  PushSDK
//
//  Created by Дмитрий Буйновский on 15/11/2020.
//  Copyright © 2020 PUSHER. All rights reserved.
//

import Foundation


class PushKDatabase {
    func save_data_after_register_ok(user_Phone: String, token: String) {
        UserDefaults.standard.set(user_Phone, forKey: "push_user_msisdn")
        PushKConstants.push_user_msisdn = user_Phone
        
        UserDefaults.standard.set(token, forKey: "push_registration_token")
        PushKConstants.push_registration_token = token
        
        UserDefaults.standard.set(true, forKey: "registrationstatus")
        PushKConstants.registrationstatus = true
        
        UserDefaults.standard.synchronize()
        
    }
}
