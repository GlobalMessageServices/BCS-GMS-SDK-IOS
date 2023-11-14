//
//  PushMessage.swift
//  PushDTest
//
//  Created by o.korniienko on 16.10.23.
//  Copyright © 2023 Дмитрий Буйновский. All rights reserved.
//

import Foundation

public struct PushMessage: Decodable{
    let messageId:String
    let title:String
    let body:String
    let phone:String
    let time: String
    let image: PushImage
    let button : PushButton
    let is2Way:Bool
}

struct PushButton: Decodable{
    let text:String
    let url:String
}

struct PushImage: Decodable{
    let url:String
}
