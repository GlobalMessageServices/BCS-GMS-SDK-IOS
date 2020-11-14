//
//  push_answer_func.swift
//  PushDemo
//
//  Created by Kirill Kotov on 28/09/2019.
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
    
    func general_answer_struct(resp_code: String, body_json: String, description: String) -> PushKGeneralAnswerStruct{
        var resp: PushKGeneralAnswerStruct = PushKGeneralAnswerStruct.init(code: 0, result: "unknown", description: "unknown", body: "unknown")
        if (resp_code=="200"){
            resp = PushKGeneralAnswerStruct.init(code: 200, result: "Ok", description: "Success", body: body_json)
        } else if (resp_code=="400"){
            resp = PushKGeneralAnswerStruct.init(code: 400, result: "Failed", description: "Failed", body: "unknown")
        } else {
            
            resp = PushKGeneralAnswerStruct.init(code: Int(resp_code) ?? 0, result: "Failed", description: "Failed", body: body_json)
        }
        return resp
    }
    
    func general_answer2(resp_code: Int, body_json: String, description: String) -> PushKFunAnswerGeneral{
        var resp: PushKFunAnswerGeneral = PushKFunAnswerGeneral(code: 710, result: "Unknown", description: description, body: body_json)
        
        if (resp_code == 200){
            resp = PushKFunAnswerGeneral(code: resp_code, result: "Ok", description: "Success", body: body_json)
        } else if (resp_code==400){
            resp = PushKFunAnswerGeneral(code: resp_code, result: "Failed", description: "Failed", body: "unknown")
            
        } else {
            resp = PushKFunAnswerGeneral(code: resp_code, result: "Failed", description: description, body: body_json)
        }
        return resp
    }
}
