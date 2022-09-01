//
//  AnswerBuider.swift
//  GMSPushSDKIOS
//
//  Created by o.korniienko on 22.08.22.
//

import Foundation


internal class AnswerBuilder {
    
    func generalAnswerStruct(respCode: Int, bodyJson: String, description: String) -> PushKGeneralAnswerStruct{
        var resp: PushKGeneralAnswerStruct = PushKGeneralAnswerStruct.init(code: 0, result: "unknown", description: "unknown", body: "unknown")
        if (respCode==200){
            resp = PushKGeneralAnswerStruct.init(code: 200, result: "Ok", description: "Success", body: bodyJson)
        } else if (respCode==400){
            resp = PushKGeneralAnswerStruct.init(code: 400, result: "Failed", description: "Failed", body: "unknown")
        } else {
            
            resp = PushKGeneralAnswerStruct.init(code: respCode, result: "Failed", description: description, body: bodyJson)
        }
        return resp
    }
    
    func generalAnswer(respCode: Int, bodyJson: String, description: String) -> PushKFunAnswerGeneral{
        var resp: PushKFunAnswerGeneral = PushKFunAnswerGeneral(code: 710, result: "Unknown", description: description, body: bodyJson)
        
        if (respCode == 200){
            resp = PushKFunAnswerGeneral(code: respCode, result: "Ok", description: "Success", body: bodyJson)
        } else if (respCode==400){
            resp = PushKFunAnswerGeneral(code: respCode, result: "Failed", description: "Failed", body: "unknown")
            
        } else {
            resp = PushKFunAnswerGeneral(code: respCode, result: "Failed", description: description, body: bodyJson)
        }
        return resp
    }
}
