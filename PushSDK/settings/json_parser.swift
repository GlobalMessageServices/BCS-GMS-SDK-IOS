//
//  json_parser.swift
//  PushSDK
//
//  Created by Kirill Kotov on 29/03/2020.
//  Copyright © 2020 PUSHER. All rights reserved.
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
        

        guard let jsonData = str_resp.data(using: .utf8) else { return RegisterJsonParse(deviceId: "", token: "", userId: 0, userPhone: "", createdAt: "")}
        //let jsonData = JSON.self(using: .utf8)!
        do {
           let parsedJson: FullRegister = try JSONDecoder().decode(FullRegister.self, from: jsonData)
           PushKConstants.logger.debug(parsedJson.session.token)
           let res = RegisterJsonParse.init(deviceId: String(parsedJson.device.deviceId), token: parsedJson.session.token, userId: parsedJson.profile.userId, userPhone: parsedJson.profile.userPhone, createdAt: parsedJson.profile.createdAt)
           return res
            
        } catch {
            let res = RegisterJsonParse.init(deviceId: "unknown", token: "unknown_token", userId: 0, userPhone: "0", createdAt: "")
            return res
        }
    }
    
    func updateregistrationJParse(str_resp: String) -> UpdateRegJsonParse
    {
        struct RegisterUpdate: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            let deviceId: Int
        }
        
        guard let jsonData = str_resp.data(using: .utf8) else { return UpdateRegJsonParse(deviceId: "")}
        //let jsonData = JSON.self(using: .utf8)!
        
        do {
            let parsedJson: RegisterUpdate = try JSONDecoder().decode(RegisterUpdate.self, from: jsonData)
            let res = UpdateRegJsonParse.init(deviceId: String(parsedJson.deviceId))
            return res
        } catch {
            let res = UpdateRegJsonParse.init(deviceId: "unknown")
            return res
        }
        
    }
    
    func getDeviceListJson(str_resp: String) -> PushKGetDeviceList
    {

        struct PushKGetDeviceListParse: Decodable {
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
        let devices: [PushKGetDeviceListParse]
    }
        
        guard let jsonData = str_resp.data(using: .utf8) else { return PushKGetDeviceList(devices: [])}
        do {
        let parsedJson: DevListRespAll = try JSONDecoder().decode(DevListRespAll.self, from: jsonData)
        
        var devPushK: [PushKGetDevice] = []
        
        for i in parsedJson.devices
        {
            let dev1: PushKGetDevice = PushKGetDevice.init(id: i.id, osType: i.osType, osVersion: i.osVersion, deviceType: i.deviceType, deviceName: i.deviceName, sdkVersion: i.sdkVersion, createdAt: i.createdAt, updatedAt: i.updatedAt)
            devPushK.append(dev1)
        }
        
        let res = PushKGetDeviceList.init(devices: devPushK)
        return res
        } catch {
            let res = PushKGetDeviceList.init(devices: [])
            return res
        }
    }
    
    
    func getMessageHistoryJson(str_resp: String) -> MessagesListResponse
    {
        
        struct ImageResponseParse: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            var url: String?=nil
        }
        
        struct ButtonResponseParse: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            var text: String?=nil
            var url: String?=nil
        }
        
        struct PushKMessageListParse: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            var phone: String?=nil
            var messageId: String?=nil
            var title: String?=nil
            var body: String?=nil
            var image: ImageResponseParse?=nil
            var button: ButtonResponseParse?=nil
            var time: String?=nil
            var partner: String?=nil
        }
        
        struct MessagesListRespAll: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }
            var limitDays: Int?=nil
            var limitMessages: Int?=nil
            var lastTime: Int?=nil
            var messages: [PushKMessageListParse]
        }
        
        guard let jsonData = str_resp.data(using: .utf8) else { return MessagesListResponse(limitDays: 0, limitMessages: 0, lastTime: 0, messages: [])}

        do {
            let parsedJson: MessagesListRespAll = try JSONDecoder().decode(MessagesListRespAll.self, from: jsonData)
            var messListPushK: [MessagesResponseStr] = []
            
            for i in parsedJson.messages
            {
                let elem3: ImageResponse = ImageResponse.init(url: i.image?.url)
                let elem2: ButtonResponse = ButtonResponse.init(text: i.button?.text, url: i.button?.url)
                let elem1: MessagesResponseStr = MessagesResponseStr.init(phone: i.phone, messageId: i.messageId, title: i.title, body: i.body, image: elem3, button: elem2, time: i.time, partner: i.partner)
                messListPushK.append(elem1)
            }
            
            let res = MessagesListResponse.init(limitDays: parsedJson.limitDays, limitMessages: parsedJson.limitMessages, lastTime: parsedJson.lastTime, messages: messListPushK)
            return res
        } catch {
            //handle error
            let res = MessagesListResponse.init(limitDays: 0, limitMessages: 0, lastTime: 0, messages: [])
            return res
        }
    }
    
    
}

