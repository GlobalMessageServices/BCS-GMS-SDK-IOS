//
//  json_parser.swift
//  HyberSDK
//
//  Created by Дмитрий Буйновский on 29/03/2020.
//  Copyright © 2020 GMS. All rights reserved.
//

import Foundation

import JSON

class AnswParser {
    
    func registerJParse(str_resp: String) -> RegisterJsonParse {
        struct RegisterSession: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let token: String
        }
        
        struct RegisterDevice: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let deviceId: Int
        }
        
        struct RegisterProfile: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let userId: Int
            let userPhone: String
            let createdAt: String
        }
        
        struct FullRegister: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let session: RegisterSession
            let profile: RegisterProfile
            let device: RegisterDevice
        }
        let jsonData = str_resp.data(using: .utf8)!
        //let jsonData = JSON.self(using: .utf8)!
        let parsedJson: FullRegister = try! JSONDecoder().decode(FullRegister.self, from: jsonData)
        print(parsedJson.session.token)
        let res = RegisterJsonParse.init(deviceId: parsedJson.device.deviceId, token: parsedJson.session.token, userId: parsedJson.profile.userId, userPhone: parsedJson.profile.userPhone, createdAt: parsedJson.profile.createdAt)
        return res
    }
    
}

