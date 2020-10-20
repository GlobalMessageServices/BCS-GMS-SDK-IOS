//
//  HyberSDKTests.swift
//  HyberSDKTests
//
//  Created by Kirill Kotov on 01/10/2020.
//  Copyright © 2020 HYBER. All rights reserved.
//

import XCTest
@testable import HyberSDK
import SwiftyBeaver

class HyberSDKTests: XCTestCase {
    
    static let logLevel: SwiftyBeaver.Level = .debug
    var sdkInitHyber = HyberSDK.init(platform_branch: PushSdkParametersPublic.branchTestValue, log_level: logLevel)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testRegistrar() {
       let resp = sdkInitHyber.hyber_register_new(user_phone: "375291234567", user_password: "1", x_hyber_sesion_id: "123", x_hyber_ios_bundle_id: "123456789", X_Hyber_Client_API_Key: "test")
        print(resp)
    }
    
    func testGetDeviceAll() {
        let resp = sdkInitHyber.hyber_get_device_all_from_hyber().result
        print(resp)
    }
    
    func testGetMessHistory() {
        let resp = sdkInitHyber.hyber_get_message_history(period_in_seconds: 12345)
        print(resp)
    }
    
    func testUpdateRegistration() {
        let resp = sdkInitHyber.hyber_update_registration().description
        print(resp)
    }
    
    func testSendDeliveryReport() {
        let resp = sdkInitHyber.hyber_message_delivery_report(message_id: "1251fqf4").description
        print(resp)
    }
    
    func testSendMessageCallback() {
        let resp = sdkInitHyber.hyber_send_message_callback(message_id: "test", message_text: "privet").description
        print(resp)
    }
    
    func testReqQueue() {
        let resp = sdkInitHyber.hyber_check_queue()
        print(resp)
    }
    
    func testClearDeviceAll() {
        let resp = sdkInitHyber.hyber_clear_all_device()
        print(resp)
    }
    
    
    
    func testPrint() {
        print("error: not a valid http response")
    }
    
    
    func testLogger () {
        let log = SwiftyBeaver.self
        let console = ConsoleDestination()
        console.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d PushSDK $T $N.$F:$l $L: $M"
        console.minLevel = .debug
        //let file = FileDestination()
        
        //log.addDestination(file)
        log.addDestination(console)
        
        log.debug("test 11111")
    }

}
