//
//  hyber_answer_func.swift
//  PushDemo
//
//  Created by ard on 28/09/2019.
//  Copyright © 2019 ard. All rights reserved.
//

import Foundation

class AnswerBuider {
    func general_answer(resp_code: String, body_json: String, description: String) -> String{
    var resp: String = String()
    if (resp_code=="200"){
    resp = "{\"result\":\"Ok\",\"description\":\"Success\",\"code\":200,\"body\":\(body_json)}"
    } else if (resp_code=="400"){
    resp = "{\"result\":\"Failed\",\"description\":\"Failed\",\"code\":400,\"body\":\"unknown\"}"
    } else {
    resp = "{\"result\":\"Failed\",\"description\":\"\(description)\",\"code\":\(resp_code),\"body\":\"\(body_json)\"}"
    }
    
    return resp
    }
}
