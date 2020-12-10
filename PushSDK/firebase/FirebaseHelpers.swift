//
//  FirebaseHelpers.swift
//  PushSDK
//
//  Created by KirillKotov on 20.11.2020.
//  Copyright © 2020 PUSHER. All rights reserved.
//

import Foundation
import FirebaseMessaging
import FirebaseCore
//import FirebaseInstanceID
import FirebaseInstallations

class PushSdkFirHelpers {
    static func firebaseUpdateToken() -> String {
        PushKConstants.logger.debug("Start firebaseUpdateToken")
        
        /*
        InstanceID.instanceID().instanceID { (result, error) in
            PushKConstants.logger.debug("Processing firebaseUpdateToken result: \(result?.token ?? ""), error: \(error.debugDescription )")
            if let error = error {
                PushKConstants.logger.debug("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                if (result.token != "") {
                    UserDefaults.standard.set(result.token, forKey: "firebase_registration_token")
                    PushKConstants.firebase_registration_token = result.token
                    UserDefaults.standard.synchronize()
                    PushKConstants.logger.debug("Remote instance ID token: \(result.token)")
                }
            }
        }
        
        PushKConstants.logger.debug("answToken token: \(PushKConstants.firebase_registration_token ?? "")")
        */
        
        
    Installations.installations().authTokenForcingRefresh(true, completion: { (token, error) in
        if let error = error {
            PushKConstants.logger.debug("Error fetching remote instance ID: \(error)")
            return
        }
        guard let token = token else { return }
        
        if (token.authToken != "") {
            UserDefaults.standard.set(token.authToken, forKey: "firebase_registration_token")
            PushKConstants.firebase_registration_token = token.authToken
            UserDefaults.standard.synchronize()
            PushKConstants.logger.debug("Remote instance ID token: \(token.authToken)")
        }
    })
        
        PushKConstants.logger.debug("answToken token: \(PushKConstants.firebase_registration_token ?? "")")

        
        return PushKConstants.firebase_registration_token ?? ""
    }
}


