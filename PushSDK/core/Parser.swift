//
//  Parser.swift
//  GMSPushSDKIOS
//
//  Created by o.korniienko on 22.08.22.
//

import Foundation


public class PusherKParser {
    
    public init() {}
    
    //let processor = PushProcessing.init()
    
    public func urlsInitialization(branchUrl: String, methodPaths: BranchStructObj) {
        if (branchUrl.last == "/")
        {
            PushKConstants.platformBrancActive = BranchStructObj(
                urlHttpUpdate: branchUrl + PushKConstants.serverSdkVersion + "/" + methodPaths.urlHttpUpdate,
                urlHttpRegistration: branchUrl + PushKConstants.serverSdkVersion + "/" + methodPaths.urlHttpRegistration,
                urlHttpRevoke: branchUrl + PushKConstants.serverSdkVersion + "/" + methodPaths.urlHttpRevoke,
                urlHttpDeviceGetAll: branchUrl + PushKConstants.serverSdkVersion + "/" + methodPaths.urlHttpDeviceGetAll,
                urlHttpMesscallback: branchUrl + PushKConstants.serverSdkVersion + "/" + methodPaths.urlHttpMesscallback,
                urlHttpMessDr: branchUrl + PushKConstants.serverSdkVersion + "/" + methodPaths.urlHttpMessDr,
                pusUrlMessQueue: branchUrl + PushKConstants.serverSdkVersion + "/" + methodPaths.pusUrlMessQueue,
                urlHttpMessHistory: branchUrl + PushKConstants.serverSdkVersion + "/" + methodPaths.urlHttpMessHistory)
        }
        else
        {
            PushKConstants.platformBrancActive = BranchStructObj(
                urlHttpUpdate: branchUrl + "/" + PushKConstants.serverSdkVersion + "/" + methodPaths.urlHttpUpdate,
                urlHttpRegistration: branchUrl + "/" + PushKConstants.serverSdkVersion + "/" + methodPaths.urlHttpRegistration,
                urlHttpRevoke: branchUrl + "/" + PushKConstants.serverSdkVersion + "/" + methodPaths.urlHttpRevoke,
                urlHttpDeviceGetAll: branchUrl + "/" + PushKConstants.serverSdkVersion + "/" + methodPaths.urlHttpDeviceGetAll,
                urlHttpMesscallback: branchUrl + "/" + PushKConstants.serverSdkVersion + "/" + methodPaths.urlHttpMesscallback,
                urlHttpMessDr: branchUrl + "/" + PushKConstants.serverSdkVersion + "/" + methodPaths.urlHttpMessDr,
                pusUrlMessQueue: branchUrl + "/" + PushKConstants.serverSdkVersion + "/" + methodPaths.pusUrlMessQueue,
                urlHttpMessHistory: branchUrl + "/" + PushKConstants.serverSdkVersion + "/" + methodPaths.urlHttpMessHistory)
        }
    }
    
    public func messIdParser(messageFromPushServer: String) -> String
    {
        
        let newStringFun = messageFromPushServer.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        //textOutput.text = newString
        PushKConstants.logger.debug(newStringFun)
        
        let deviceIdFunc = self.matches(for: "\"messageId\":\"(.{4,9}-.{3,9}-.{3,9}-.{3,9}-.{4,15})\"", in: newStringFun)
        PushKConstants.logger.debug(deviceIdFunc)
        
        guard let jsonDataTransf = try? JSONSerialization.data(withJSONObject: deviceIdFunc, options: []) else { return "" }
        let jsonString = String(data: jsonDataTransf, encoding: .utf8) ?? ""
        let newString = String(jsonString).replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        PushKConstants.logger.debug(newString)
        
        let iterationString = newString.replacingOccurrences(of: "[\"\"messageId\":\"", with: "", options: .literal, range: nil)
        let finalString = iterationString.replacingOccurrences(of: "\",\"\"]", with: "", options: .literal, range: nil)
        
        return finalString
    }
    
    public func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))

              let resp = results.map {
                String(text[Range($0.range, in: text)!])
              }
            return resp
        } catch let error {
            PushKConstants.logger.error("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}

