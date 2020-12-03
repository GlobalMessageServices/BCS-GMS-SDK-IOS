//
//  add_functions.swift
//  test222
//
//  Created by Kirill Kotov on 28/04/2019.
//  Copyright © 2019 ard. All rights reserved.
//

import Foundation

class PushKProcessing {
    
    
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
