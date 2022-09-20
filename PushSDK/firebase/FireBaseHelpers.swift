//
//  FireBaseHelpers.swift
//  GMSPushSDKIOS
//
//  Created by o.korniienko on 22.08.22.
//

import Foundation
import FirebaseMessaging
import FirebaseCore
//import FirebaseInstanceID
import FirebaseInstallations

internal class PushSdkFirHelpers {
    static func firebaseUpdateToken() -> String {
        PushKConstants.logger.debug("Start firebaseUpdateToken")
        
    Installations.installations().authTokenForcingRefresh(true, completion: { (token, error) in
        if let error = error {
            PushKConstants.logger.debug("Error fetching remote instance ID: \(error)")
            return
        }
        guard let token = token else { return }
        
        PushKConstants.logger.debug("Remote Instance ID token: \(token.authToken)")

    })
        
        PushKConstants.logger.debug("old token: \(PushKConstants.firebaseRegistrationToken ?? "")")
        
        let tokenFcm = String(Messaging.messaging().fcmToken ?? "")
        if (tokenFcm != "") {
            UserDefaults.standard.set(tokenFcm, forKey: "firebase_registration_token")
            PushKConstants.firebaseRegistrationToken = tokenFcm
            UserDefaults.standard.synchronize()
            PushKConstants.logger.debug("FCM token: \(tokenFcm)")
        }
        
        return PushKConstants.firebaseRegistrationToken ?? ""
    }
}
