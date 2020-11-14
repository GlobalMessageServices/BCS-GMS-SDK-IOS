//
//  add_functions.swift
//  test222
//
//  Created by Kirill Kotov on 28/04/2019.
//  Copyright © 2019 ard. All rights reserved.
//

import Foundation

public class Processing {
    
    public init() {}
    
    //function for write debug log into additional file. Calling from procedures
    func file_logger(message: String, loglevel: String){
            if (PushKConstants.loglevel==".debug") {
                log_wr(message: message, loglevel: loglevel)
            }else if (PushKConstants.loglevel==".errors" && (loglevel==".error" || loglevel==".critical") ){
                log_wr(message: message, loglevel: loglevel)
            }else if (PushKConstants.loglevel==".critical" && loglevel==".critical"){
                log_wr(message: message, loglevel: loglevel)
            }else{
                //if another level in loglevel
            }
    }
    
    private func log_wr(message: String, loglevel: String){
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //let date = Date()
        //let dateString = dateFormatter.string(from: date)
        //let fileURL = URL(fileURLWithPath: Constants.debug_log_path)
        //let text = "\(dateString) \(Constants.application_name) \(loglevel) message: \(message)\n"
        //try! text.write(to: fileURL, atomically: false, encoding: .utf8)
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
