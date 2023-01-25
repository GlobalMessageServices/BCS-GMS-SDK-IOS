//
//  JsonParser.swift
//  GMSPushSDKIOS
//
//  Created by o.korniienko on 22.08.22.
//

import Foundation

class PushServerAnswParser {
    
    func registerJParse(strResp: String) -> RegisterJsonParse {
        PushKConstants.logger.debug("registerJParse start: strResp: \(strResp)")

        do {
           let jsonData = Data(strResp.utf8)
           let parsedJson: FullRegister = try JSONDecoder().decode(FullRegister.self, from: jsonData)
           PushKConstants.logger.debug(parsedJson.session.token)
           let res = RegisterJsonParse.init(deviceId: String(parsedJson.device.deviceId), token: parsedJson.session.token, userId: parsedJson.profile.userId, userPhone: parsedJson.profile.userPhone, createdAt: parsedJson.profile.createdAt)
           return res
            
        } catch {
            PushKConstants.logger.debug("registerJParse error: \(error.localizedDescription)")
            let res = RegisterJsonParse.init(deviceId: "unknown", token: "unknown_token", userId: 0, userPhone: "0", createdAt: "")
            return res
        }
    }
    

    
    func updateregistrationJParse(strResp: String) -> UpdateRegJsonParse {
        
        PushKConstants.logger.debug("updateregistrationJParse start: strResp: \(strResp)")
        
        do {
            let jsonData = Data(strResp.utf8)
            let parsedJson: RegisterUpdate = try JSONDecoder().decode(RegisterUpdate.self, from: jsonData)
            let res = UpdateRegJsonParse.init(deviceId: String(parsedJson.deviceId))
            return res
        } catch {
            PushKConstants.logger.debug("updateregistrationJParse error: \(error.localizedDescription)")
            let res = UpdateRegJsonParse.init(deviceId: "unknown")
            return res
        }
        
    }
    
    func getDeviceListJson(strResp: String) -> PushKGetDeviceList {

        PushKConstants.logger.debug("getDeviceListJson start: strResp: \(strResp)")
        
        do {
            let jsonData = Data(strResp.utf8)
            let parsedJson: DevListRespAll = try JSONDecoder().decode(DevListRespAll.self, from: jsonData)
        
            var devPushK: [PushKGetDevice] = []
        
            for i in parsedJson.devices{
                let dev1: PushKGetDevice = PushKGetDevice.init(id: i.id, osType: i.osType, osVersion: i.osVersion, deviceType: i.deviceType, deviceName: i.deviceName, sdkVersion: i.sdkVersion, createdAt: i.createdAt, updatedAt: i.updatedAt)
                devPushK.append(dev1)
            }
        
            let res = PushKGetDeviceList.init(devices: devPushK)
            return res
        } catch {
            PushKConstants.logger.debug("getDeviceListJson error: \(error.localizedDescription)")
            let res = PushKGetDeviceList.init(devices: [])
            return res
        }
    }
    
    
    func getMessageHistoryJson(strResp: String) -> MessagesListResponse{
        
        PushKConstants.logger.debug("getMessageHistoryJson start: strResp: \(strResp)")

        do {
            let jsonData = Data(strResp.utf8)
            let parsedJson: MessagesListRespAll = try JSONDecoder().decode(MessagesListRespAll.self, from: jsonData)
            var messListPushK: [MessagesResponseStr] = []
            
            for i in parsedJson.messages{
                let elem3: ImageResponse = ImageResponse.init(url: i.image?.url)
                let elem2: ButtonResponse = ButtonResponse.init(text: i.button?.text, url: i.button?.url)
                let elem1: MessagesResponseStr = MessagesResponseStr.init(phone: i.phone, messageId: i.messageId, title: i.title, body: i.body, image: elem3, button: elem2, time: i.time, partner: i.partner)
                messListPushK.append(elem1)
            }
            
            let res = MessagesListResponse.init(limitDays: parsedJson.limitDays, limitMessages: parsedJson.limitMessages, lastTime: parsedJson.lastTime, messages: messListPushK)
            return res
        } catch {
            PushKConstants.logger.debug("getMessageHistoryJson error: \(error.localizedDescription)")
            let res = MessagesListResponse.init(limitDays: 0, limitMessages: 0, lastTime: 0, messages: [])
            return res
        }
    }
    
    
    
    static func messageIncomingJson(strResp: String) -> FullFirebaseMessageStr
    {
        PushKConstants.logger.debug("messageIncomingJson start: strResp: \(strResp)")
        
        do {
            let strRespReplaced = strResp.replacingOccurrences(of: "\"{", with: "{").replacingOccurrences(of: "}\"", with: "}")
            PushKConstants.logger.debug("messageIncomingJson before decoding: strRespTransform: \(strRespReplaced)")
            
            let jsonData = Data(strRespReplaced.utf8)
            PushKConstants.logger.debug("messageIncomingJson transformed to data")
            
            let parsedJson: FullFirebaseMessage = try JSONDecoder().decode(FullFirebaseMessage.self, from: jsonData)
            
            PushKConstants.logger.debug("messageIncomingJson parsedJson: \(parsedJson)")
            
            let elem1: ImageResponse = ImageResponse.init(url: parsedJson.message?.image?.url)
            let elem2: ButtonResponse = ButtonResponse.init(text: parsedJson.message?.button?.text, url: parsedJson.message?.button?.url)
            let elem3: MessagesResponseStr = MessagesResponseStr.init(phone: parsedJson.message?.phone, messageId: parsedJson.message?.messageId, title: parsedJson.message?.title, body: parsedJson.message?.body, image: elem1, button: elem2, time: parsedJson.message?.time, partner: parsedJson.message?.partner, is2Way: parsedJson.message?.is2Way)
            
            let res = FullFirebaseMessageStr.init(aps: MessApsDataStr(contentAvailable: parsedJson.aps?.contentavailable ?? 0),
                                               message: elem3,
                                               googleCSenderId: parsedJson.googlecsenderid ?? "",
                                               gcmMessageId: parsedJson.gcmmessageid ?? "")
            
            PushKConstants.logger.debug("messageIncomingJson parsedJson2.message?.body: \(String(parsedJson.message?.body ?? "empty"))")
            PushKConstants.logger.debug("messageIncomingJson parsedJson2.message?.messageId: \(String(parsedJson.message?.messageId ?? "empty"))")
            
            return res
        } catch {
            PushKConstants.logger.debug("getMessageHistoryJson error: \(error.localizedDescription)")
            let res = FullFirebaseMessageStr.init(aps: MessApsDataStr(contentAvailable: 0),
                                                  message: MessagesResponseStr(phone: "", messageId: "", title: "", body: "", image: ImageResponse(url: ""), button: ButtonResponse(text: "", url: ""), time: "", partner: ""),
                                                  googleCSenderId: "",
                                               gcmMessageId: "")
            return res
        }
    }
    
    
}


// DECODALE SRUCTURS

// related to message parsing
struct ButtonResponseParse: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    var text: String?=nil
    var url: String?=nil
}

struct MessApsData: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    enum CodingKeys: String, CodingKey {
            case contentavailable = "content-available"
        }
    var contentavailable: Int? = 0
}

struct ImageResponseParse: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    var url: String?=nil
}

struct PushKMessageListParse: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    var image: ImageResponseParse?=nil
    var button: ButtonResponseParse?=nil
    var partner: String?=nil
    var phone: String?=nil
    var messageId: String?=nil
    var time: String?=nil
    var body: String?=nil
    var title: String?=nil
    var is2Way: Bool?=false
}

struct FullFirebaseMessage: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    enum CodingKeys: String, CodingKey {
            case gcmmessageid = "gcm.message_id"
            case message = "message"
            case googlecsenderid = "google.c.sender.id"
            case aps = "aps"
            case source = "source"
        }
    var aps: MessApsData?=nil
    var googlecsenderid: String? = ""
    var message: PushKMessageListParse?=nil
    var gcmmessageid: String? = ""
    var source: String? = ""
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


// registration parsing
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

//registration update parsing
struct RegisterUpdate: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    let deviceId: Int
}

//get devices parsing
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

