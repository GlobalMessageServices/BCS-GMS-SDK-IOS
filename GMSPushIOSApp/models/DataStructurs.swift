//
//  DataStructurs.swift
//  GMSPushIOSApp
//
//  Created by o.korniienko on 30.05.22.
//

import Foundation

public struct PushRegisterAnswer{
    
    public var id: Int64
    public var deviceId: String
    public var token: String
    public var userId: String
    public var userPhone: String
    public var createdAt: String
    
    public func toString() -> String {
        return "PushKFunAnswerRegister(code: \(self.id), deviceId: \(self.deviceId), token: \(self.token), userId: \(self.userId), userPhone: \(self.userPhone), createdAt: \(self.createdAt))"
    }
    
    
}

public struct MessagesResponseStr : Decodable {
    public var phone: String?=""
    public var messageId: String?=""
    public var title: String?=""
    public var body: String?=""
    public var image: ImageResponse?
    public var time: String?=""
    public var partner: String?=""
    
    public func toString() -> String {
        return "MessagesResponseStr(phone: \(self.phone ?? ""), messageId: \(self.messageId ?? ""), title: \(self.title ?? ""), body: \(self.body ?? ""), image: \(self.image?.toString() ?? ""),  time: \(self.time ?? ""), partner: \(self.partner ?? ""))"
    }
}

public struct ImageResponse: Decodable {
    public var url: String?=""
    
    public func toString() -> String {
        return "ImageResponse(url: \(self.url ?? ""))"
    }
}

public struct QueueResponse: Decodable{
    public var messages : Array<MessagesResponseStr>
}


