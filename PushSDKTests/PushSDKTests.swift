//
//  PushSDKTests.swift
//  PushSDKTests
//
//  Created by Kirill Kotov on 09/01/2020.
//  Copyright © 2020 PUSHER. All rights reserved.
//

import XCTest
@testable import PushSDK
import SwiftyBeaver

class PushSDKTests: XCTestCase {
    
    static let logLevel: SwiftyBeaver.Level = .debug
    var sdkInitPush = PushSDK.init(platform_branch: PushSdkParametersPublic.branchMasterValue, log_level: logLevel, basePushURL: "https://example.com")
    
    let parser_class = PusherKParser.init()


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
        let resp = sdkInitPush.push_register_new(user_phone: "375291234567", user_password: "1", x_push_sesion_id: "123", x_push_ios_bundle_id: "123456789", X_Push_Client_API_Key: "test")
        print(resp)
    }
    
    func testGetDeviceAll() {
        let resp = sdkInitPush.push_get_device_all_from_server().result
        print(resp)
    }
    
    func testGetMessHistory() {
        let resp = sdkInitPush.push_get_message_history(period_in_seconds: 12345)
        print(resp)
    }
    
    func testUpdateRegistration() {
        let resp = sdkInitPush.push_update_registration().description
        print(resp)
    }
    
    func testSendDeliveryReport() {
        let resp = sdkInitPush.push_message_delivery_report(message_id: "1251fqf4").description
        print(resp)
    }
    
    func testSendMessageCallback() {
        let resp = sdkInitPush.push_send_message_callback(message_id: "test", message_text: "privet").description
        print(resp)
    }
    
    func testReqQueue() {
        let resp = sdkInitPush.push_check_queue()
        print(resp)
    }
    
    func testClearDeviceAll() {
        let resp = sdkInitPush.push_clear_all_device()
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
    
    func testParser()  {
        parser_class.urls_initialization(branchUrl: "https://test/", method_paths: PushSdkParametersPublic.branchMasterValue)
    }
    
    func testGetInfo() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        print(appVersion)
        let object = NSStringFromClass(PushSDK.self) as NSString
        let module = object.components(separatedBy: ".").first!
        print(module)
    }


}
