import Flutter
import UIKit
import Amplify
import AmplifyPlugins

public class SwiftAwsAnalyticsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "aws_analytics", binaryMessenger: registrar.messenger())
    let instance = SwiftAwsAnalyticsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
      case "initialize":
        initialize(result: result)
        break
      case "registerGlobalProperties":
      let arguments = call.arguments as! [String:Any]
        registerGlobalProperties(properties: arguments, result: result)
        break
      case "unregisterGlobalProperties":
        unregisterGlobalProperties(properties: (call.arguments as? Array<String>), result: result)
        break
      case "record":
        let arguments = call.arguments as! Dictionary<String,Any>
        record(eventName: (arguments["event"] as! String), properties: (arguments["properties"] as! [String:Any]), result: result)
        break
      default: result(FlutterMethodNotImplemented)
    }
  }

  func initialize(result: FlutterResult) {
    print("starting initialize")
    do {
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.configure()
        try Amplify.add(plugin: AWSPinpointAnalyticsPlugin())
        try Amplify.configure()
        print("Amplify configured with Auth and Analytics plugins")
        result(true)
    } catch {
        print("Failed to initialize Amplify with \(error)")
        result(false)
    }
  }

  func registerGlobalProperties(properties: [String:Any], result: FlutterResult) {
    let properties = ["userPropertyStringKey": "userProperyStringValue",
                          "userPropertyIntKey": 123,
                          "userPropertyDoubleKey": 12.34,
                          "userPropertyBoolKey": true] as [String: AnalyticsPropertyValue]
    do {
    try Amplify.configure()
  } catch {
    print("Failed to initialize Amplify with \(error)")
  }
    Amplify.Analytics.registerGlobalProperties(properties)
    result(true)
  }

  func unregisterGlobalProperties(properties: Array<String>?, result: FlutterResult) {
    do {
    try Amplify.configure()
  } catch {
    print("Failed to initialize Amplify with \(error)")
  }

    if let properties = properties {
      let objectSet = Set(properties.map { $0 })
      Amplify.Analytics.unregisterGlobalProperties(objectSet)
    } else {
      Amplify.Analytics.unregisterGlobalProperties()
    }
    result(true)
  }

  func record(eventName: String, properties: [String:Any], result: FlutterResult) {
    let properties = ["userPropertyStringKey": "test",
                          "userPropertyIntKey": 1,
                          "userPropertyDoubleKey": 1.34,
                          "userPropertyBoolKey": true] as [String: AnalyticsPropertyValue]
    let event = BasicAnalyticsEvent(name: eventName, properties: properties)
    do {
    try Amplify.configure()
  } catch {
    print("Failed to initialize Amplify with \(error)")
  }

    Amplify.Analytics.record(event: event)
    result(true)
  }
}
