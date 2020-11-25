//
//  PushSDKTests.swift
//  PushSDKTests
//
//  Created by Kirill Kotov on 09/01/2020.
//  Copyright © 2020 PUSHER. All rights reserved.
//

import XCTest
@testable import PushSDK

class PushSDKTests: XCTestCase {
    
    var sdkInitPush = PushSDK.init(platform_branch: PushSDKVar.branchMasterValue, log_level: PushSDKVar.LOGLEVEL_DEBUG, basePushURL: "https://example.com")
    
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
        let resp = sdkInitPush.pushRegisterNew(user_phone: "375291234567", user_password: "1", x_push_sesion_id: "123", x_push_ios_bundle_id: "123456789", X_Push_Client_API_Key: "test")
        print(resp)
    }
    
    func testGetDeviceAll() {
        let resp = sdkInitPush.pushGetDeviceAllFromServer().result
        print(resp)
    }
    
    func testGetMessHistory() {
        let resp = sdkInitPush.pushGetMessageHistory(period_in_seconds: 12345)
        print(resp)
    }
    
    func testUpdateRegistration() {
        let resp = sdkInitPush.pushUpdateRegistration().description
        print(resp)
    }
    
    func testSendDeliveryReport() {
        let resp = sdkInitPush.pushMessageDeliveryReport(message_id: "1251fqf4").description
        print(resp)
    }
    
    func testSendMessageCallback() {
        let resp = sdkInitPush.pushSendMessageCallback(message_id: "test", message_text: "privet").description
        print(resp)
    }
    
    func testReqQueue() {
        let resp = sdkInitPush.pushCheckQueue()
        print(resp)
    }
    
    func testClearDeviceAll() {
        let resp = sdkInitPush.pushClearAllDevice()
        print(resp)
    }
    
    


    
    func testGetInfo() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        print(appVersion)
        let object = NSStringFromClass(PushSDK.self) as NSString
        let module = object.components(separatedBy: ".").first!
        print(module)
    }


}
