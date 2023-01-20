//
//  InfoManager.swift
//  PushSDK
//
//  Created by o.korniienko on 19.01.23.
//

import Foundation
import CoreLocation

class InfoManager: NSObject, CLLocationManagerDelegate {
    
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    
    override init() {
        super.init()
        locationManager.requestAlwaysAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled(){
                self.locationManager.delegate = self
                self.locationManager.startMonitoringSignificantLocationChanges()
            }
            
        }
    }
    
    
    
    static func getLanguageAndRegion()-> LanguageAndRegion{
        let preferLanguage = Locale.preferredLanguages.first ?? "n/a"
        
        if preferLanguage == "n/a"{
            return LanguageAndRegion(deviceLanguage: "n/a", deviceLanguageEn: "n/a", isoLanguageCode: "n/a", isoRegion: "n/a", region: "n/a", regionEn: "n/a")
        }
        let locale = NSLocale(localeIdentifier: preferLanguage)
        let localeEn = NSLocale(localeIdentifier: "en_EN")
        
        let language = locale.localizedString(forLanguageCode: locale.languageCode)
        let languageEn = localeEn.localizedString(forLanguageCode: locale.languageCode)
        let region = locale.localizedString(forCountryCode: locale.countryCode ?? "en")
        let regionEn = localeEn.localizedString(forCountryCode: locale.countryCode ?? "en")
        
        return LanguageAndRegion(deviceLanguage: language ?? "n/a",
                                 deviceLanguageEn: languageEn ?? "n/a",
                                 isoLanguageCode: locale.languageCode,
                                 isoRegion: region ?? "n/a",
                                 region: regionEn ?? "n/a",
                                 regionEn: locale.countryCode ?? "n/a")
    }
    
    
    func isLocationServicesEnaled()->Bool{
        return CLLocationManager.locationServicesEnabled()
    }
    
    
    
}
