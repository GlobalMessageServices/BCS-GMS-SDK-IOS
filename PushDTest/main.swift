//
//  main.swift
//  PushDemo
//


import Foundation
import HyberSDK


import UIKit


UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    //NSStringFromClass(MyApplication.self),
    NSStringFromClass(AppDelegate.self),
    NSStringFromClass(HyberAppDelegatePush.self)
    //NSStringFromClass(SkAppDelegatePush.self)
    //NSStringFromClass(AppDelegate.self)
)


