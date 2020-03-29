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
        let res = RegisterJsonParse.init(deviceId: String(parsedJson.device.deviceId), token: parsedJson.session.token, userId: parsedJson.profile.userId, userPhone: parsedJson.profile.userPhone, createdAt: parsedJson.profile.createdAt)
        return res
    }
    
    
    
    func updateregistrationJParse(str_resp: String) -> UpdateRegJsonParse
    {
        struct RegisterUpdate: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let deviceId: Int
        }
        
        let jsonData = str_resp.data(using: .utf8)!
        //let jsonData = JSON.self(using: .utf8)!
        let parsedJson: RegisterUpdate = try! JSONDecoder().decode(RegisterUpdate.self, from: jsonData)
        let res = UpdateRegJsonParse.init(deviceId: String(parsedJson.deviceId))
        return res
    }
    
    func getDeviceListJson(str_resp: String) -> HyberGetDeviceList
    {

        struct HyberGetDeviceListParse: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            var id : Int
            var osType: String
            var osVersion: String
            var deviceType: String
            var deviceName: String
            var sdkVersion: String
            var createdAt: String
            var updatedAt: String
        }
        
    struct DevListRespAll: Decodable {
        enum Category: String, Decodable {
            case swift, combine, debugging, xcode
        }
        let devices: [HyberGetDeviceListParse]
    }
        
        let jsonData = str_resp.data(using: .utf8)!
        //let jsonData = JSON.self(using: .utf8)!
        let parsedJson: DevListRespAll = try! JSONDecoder().decode(DevListRespAll.self, from: jsonData)
        
        var devHyber: [HyberGetDevice] = []
        
        for i in parsedJson.devices
        {
            let dev1: HyberGetDevice = HyberGetDevice.init(id: i.id, osType: i.osType, osVersion: i.osVersion, deviceType: i.deviceType, deviceName: i.deviceName, sdkVersion: i.sdkVersion, createdAt: i.createdAt, updatedAt: i.updatedAt)
            devHyber.append(dev1)
        }
        
        let res = HyberGetDeviceList.init(devices: devHyber)
        return res
        
    }
    
    
    
    
    
}

