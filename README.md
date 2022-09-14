# IOS PushSDK

***
Install and init Cocoapods.<br>
Open a terminal window and run $ sudo gem install cocoapods to instal Cocoapods.<br>
Then $ cd into your project directory and run $ pod init to create a Podfile. Important ! Before run $ pod init your project should be closed.<br>
To update dependencies in the Podfile run - $ pod update.<br>
To open your project run $ open ProjectName.xcworkspace<br>
More about Cocoapods and Podfile here - https://cocoapods.org, https://guides.cocoapods.org/using/the-podfile.html and https://guides.cocoapods.org/using/using-cocoapods.html.

last actual SDK version: 1.1.0.1<br>
To integrate PushSDK to your project with COCOAPODS (https://guides.cocoapods.org/using/the-podfile.html) add the next line in Podfile.<br>
pod 'PushSDK', :git => 'https://github.com/GlobalMessageServices/BCS-GMS-SDK-IOS', :branch => 'gmsapi'

***

* Example of PushSDK initializing
```swift
let pushAdapterSdk = PushSDK.init(basePushURL: "https://push.example.com/api/", enableNotification: true, enableDeliveryReportAuto: true, deliveryReportLogic:1)
```
***

***
Notification/delivery reports control
You can enable/disable displaying notification and sending delivery reports with the following optional parameters in PushSDK:
-	enableNotification: Bool - enable/disable display notification. Default is true (enabled) 
-	enableDeliveryReportAuto: Bool - enable/disable sending delivery report. Default is true (enabled) 
-	deliveryReportLogic: Int - working if enableNotification is true and enableDeliveryReportAuto is true. Options of deliveryReportLogic:<br>
                   1 - if notification permitted in application settings, then send delivery report. Else not send report<br>
                   2 - always send delivery report if receive message
***


#SDK functions description

All this functions are available from PushSDK class
For using it, create this class new instance first

***
* New device registration. Register your device on push server
```swift
public func pushRegisterNew(userPhone: String, userPassword: String, xPushSessionId: String, xPushIOSBundleId: String, xPushClientAPIKey: String) -> PushKFunAnswerRegister

public func pushRegisterNew(userPhone: String, userPassword: String, xPushIOSBundleId: String, xPushClientAPIKey: String)->PushKFunAnswerRegister
```
***

* Clear local device on server. This function clear on push server only locally saved device id
```swift
public func pushClearCurrentDevice()->PushKGeneralAnswerStruct
```
***

* get message history
```swift
public func pushGetMessageHistory(periodInSeconds: Int) -> PushKFunAnswerGetMessageHistory
```
***

* Check message queue
```swift
public func pushCheckQueue() -> PushKFunAnswerGeneral
```
***

* Get all devices from server
```swift
public func pushGetDeviceAllFromServer() -> PushKFunAnswerGetDeviceList
```
***

* update firebase token on push server. Update your token on firebase platform first
```swift
public func pushUpdateRegistration() -> PushKGeneralAnswerStruct
```
***

* message callback
```swift
public func pushSendMessageCallback(messageId: String, callbackText: String) -> PushKGeneralAnswerStruct
```
***

* Send delivery report to server
```swift
public func pushMessageDeliveryReport(messageId: String) -> PushKGeneralAnswerStruct
```
***

* Clear all devices registered with current msisdn
```swift
public func pushClearAllDevice()->PushKGeneralAnswerStruct 
```
***

* Parse incoming notification
```swift
public static func parseIncomingPush(message: Notification) -> PushKMess 
```
***

* Parse incoming notification UserInfo
```swift
public static func parseIncomingPush(message:  [AnyHashable : Any]) -> PushKMess
```
***
