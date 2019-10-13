//
//  sksdkTests.swift
//  sksdkTests
//
//  Created by Дмитрий Буйновский on 08/05/2019.
//  Copyright © 2019 Дмитрий Буйновский. All rights reserved.
//

import XCTest
@testable import sksdk

class sksdkTests: XCTestCase {

    var sessionUnderTest: URLSession!
    
    var ttttt: sksdk.Svyazcom!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        //sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
        ttttt = sksdk.Svyazcom.init()
    }
    
    override func tearDown() {
        ttttt = nil
        super.tearDown()
    }
    
    func testDhdjlhjkh(){
        //let tt = "hhh"
        print ("print sdk parameters")
        //let ttttt2 = sksdk.SDKinit.init()
        //ttttt2.uuidprint()
        
        //let timet = Int(round(TimeInterval) as Double)
        //print(timet)
        
        
        //let ddd = sksdk.HyberLogger.init()
       // sksdk.HyberLogger.error("Error.self")
    }
    
    

    func testValidCallToiTunesGetsHTTPStatusCode200() {
        // given
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        // 1
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    //}

    //func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    //}

    //func testPerformanceExample() {
        // This is an example of a performance test case.
        //self.measure {
            // Put the code you want to measure the time of here.
        //}
    //}
    
    func testProcedures(){
        let dima = SKrest.init()
        //dima.sk_device_register()
        
        //dima.sk_device_revoke(dev_list:["22"], X_Hyber_Session_Id:"22", X_Hyber_Auth_Token:"674f3b5cdd724c3d9da1136fcf35da59")
        
        //dima.sk_device_update(fcm_Token: "22", os_Type: "android", os_Version: "8.0.1", device_Type: "phone", device_Name: "herolte : SM-G930F", sdk_Version: "2.2.2", X_Hyber_Session_Id: "22", X_Hyber_Auth_Token:"674f3b5cdd724c3d9da1136fcf35da59")
        
        //dima.sk_device_get_all(X_Hyber_Session_Id: "22", X_Hyber_Auth_Token: "674f3b5cdd724c3d9da1136fcf35da59")
        
        //dima.sk_message_get_history(utc_time: String(utcTimeZoneStr), X_Hyber_Session_Id: "22", X_Hyber_Auth_Token:"674f3b5cdd724c3d9da1136fcf35da59")
    }
    
    func testLogtest(){
        let ddd = Processing.init()
        ddd.file_logger(message: "dima", loglevel: ".debug")
        ddd.file_logger(message: "dima2", loglevel: ".debug")
        ddd.file_logger(message: "dima3", loglevel: ".debug")
        print("dddddd")
        print("dfsdasg")
    }
    
    
    func test_sk_device_register() {
        let sds = Svyazcom.init()
        
        
        //XCTAssertEqual(sds.test(), 5 , "tttt")

    }
    
    func testAppendLog() {

        let fileName = "myFileName.txt"
        var filePath = "/Users/imperituroard/Desktop"
        
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + fileName)
            print("Local path = \(filePath)")
        } else {
            print("Could not find local directory to store file")
            return
        }
        
        // Set the contents
        let fileContentToWrite = "Text to be recorded into file"
        
        do {
            // Write contents to file
            try fileContentToWrite.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
        
        
        // Read file content. Example in Swift
        do {
            // Read file content
            let contentFromFile = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
            print(contentFromFile)
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
        
    }

}
