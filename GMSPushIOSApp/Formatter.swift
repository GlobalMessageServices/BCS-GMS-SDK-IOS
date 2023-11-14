//
//  Formatter.swift
//  GMSPushIOSApp
//
//  Created by o.korniienko on 03.06.22.
//

import Foundation

class CustomFormatter{
    
    class func formateDate(input: String) -> String{
        var result = ""
        if input == "" {
            return ""
        }
        var dateFoormater = DateFormatter()
        dateFoormater.timeZone = TimeZone(abbreviation: "UTC")
        dateFoormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateStr = input.split(separator: ".")[0]
        
        let utcDate = dateFoormater.date(from: String(dateStr))
        dateFoormater.timeZone = TimeZone.current
        dateFoormater.dateFormat = "dd MMM yyyy HH:mm"
        result = dateFoormater.string(from: utcDate!)
        
        return result
    }
}
