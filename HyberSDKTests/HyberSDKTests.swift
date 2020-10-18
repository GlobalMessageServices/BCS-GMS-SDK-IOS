//
//  HyberSDKTests.swift
//  HyberSDKTests
//
//  Created by Kirill Kotov on 01/10/2020.
//  Copyright © 2020 HYBER. All rights reserved.
//

import XCTest
@testable import HyberSDK

class HyberSDKTests: XCTestCase {
    
    var sdkInitHyber = HyberSDK.init()

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
    
    //func testRegistrar() {
   //     sdkInitHyber.hyber_register_new(user_phone: "375291234567", user_password: "Password", x_hyber_sesion_id: "123", x_hyber_ios_bundle_id: "test", X_Hyber_Client_API_Key: "test")
   // }
    
    func testPrint() {
        print("error: not a valid http response")
    }

}
