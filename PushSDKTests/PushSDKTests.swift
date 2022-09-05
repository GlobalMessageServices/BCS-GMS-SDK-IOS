//
//  PushSDKTests.swift
//  PushSDKTests
//
//  Created by o.korniienko on 01.09.22.
//

import XCTest
@testable import PushSDK

class PushSDKTests: XCTestCase {
    
    var sdkInitPush: PushSDK!
    let parser_class = PushServerAnswParser.init()
    var userInfo : [AnyHashable:Any]!
    
    let reg_str = "{\"session\": {\"token\": \"4fab048ae89f4b98890b3e5dc800000a\"}, \"profile\": {\"userId\": 1500051, \"userPhone\": \"1234567890\", \"createdAt\": \"2022-05-09T08:22:30.893636+00\"}, \"device\": {\"deviceId\": 13000522}}"
    
    let upd_str = "{\"deviceId\": 13000522}"
    
    let all_device_str = "{\"devices\": [{\"id\": 10002522, \"osType\": \"ios\", \"osVersion\": \"15.5\", \"deviceType\": \"iPhone\", \"deviceName\": \"Simulator iPhone 11\", \"sdkVersion\": \"1.0.0.01\", \"createdAt\": \"2022-09-03T09:08:30.749255+00\", \"updatedAt\": \"2022-09-03T09:16:24.199570+00\"}, {\"id\": 10002524, \"osType\": \"ios\", \"osVersion\": \"15.6.1\", \"deviceType\": \"iPhone\", \"deviceName\": \"iPhone 11\", \"sdkVersion\": \"0.0.01\", \"createdAt\": \"2022-09-03T09:18:17.623499+00\", \"updatedAt\": \"2022-09-03T09:18:17.623499+00\"}]}"
    
    let history_str = "{\"limitDays\": 92, \"limitMessages\": 1000, \"lastTime\": 1662197023, \"messages\": [{\"body\": \"Test Message IOS 2\", \"time\": \"2022-09-03T09:23:37.372843+00\", \"image\": {}, \"phone\": \"1234567890\", \"title\": \"Test title IOS\", \"button\": {}, \"partner\": \"push\", \"messageId\": \"16f68e44-0000-0000-0000-005056010cc1\"}, {\"body\": \"Test Message IOS 1\", \"time\": \"2022-09-03T09:23:24.414771+00\", \"image\": {}, \"phone\": \"1234567890\", \"title\": \"Test title IOS\", \"button\": {}, \"partner\": \"push\", \"messageId\": \"0f45dcae-0000-0000-0000-005056010cc1\"}]}"
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sdkInitPush = PushSDK.init(platform_branch: PushSDKVar.branchMasterValue, log_level: PushSDKVar.LOGLEVEL_DEBUG, basePushURL: "https://example.com")
        userInfo = ["google.c.sender.id":"c-znu3aVxkB3redvr1HRgk", "aps": "{\"content-available\" = 1;}", "message": "{\"button\":{},\"image\":{},\"partner\":\"push\",\"phone\":\"1234567890\",\"messageId\":\"70f3cb2d-0000-0000-0000-005056010cc1\",\"time\":\"2022-09-02T12:04:49.204689+00\",\"body\":\"Test Message IOS 1\",\"title\":\"Test title IOS\"}","gcm.message_id": 8730000458611]
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testRegistration() {
        let resp = sdkInitPush.pushRegisterNew(user_phone: "1234567890", user_password: "1", x_push_sesion_id: "123", x_push_ios_bundle_id: "123456789", X_Push_Client_API_Key: "test")
        print(resp)
    }

    func testGetAllDevices() {
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
        print(appVersion ?? "unknown_empty")
        let object = NSStringFromClass(PushSDK.self) as NSString
        let module = object.components(separatedBy: ".").first!
        print(module)
    }

    func testNotificationParser(){
       var notif: Notification = Notification.init(name: Notification.Name("pushSDKReceiveData"))
        notif.userInfo = userInfo
       let result =  PushSDK.parseIncomingPush(message: notif)
       print(result)

    }

    func testUserInfoParser(){
        let result =  PushSDK.parseIncomingPush(message: userInfo)
        print(result)
    }
    
    
    func testRegParser(){
        let response = parser_class.registerJParse(str_resp: reg_str)
        print(response)
    }

    func testUpdParser(){
        let response = parser_class.updateregistrationJParse(str_resp: upd_str)
        print(response)
    }
    
    func testAllDeviceParser(){
        let response = parser_class.getDeviceListJson(str_resp: all_device_str)
        print(response)
    }
    
    func testHistoryParser(){
        let response = parser_class.getMessageHistoryJson(str_resp: history_str)
        print(response)
    }
    
    
}


