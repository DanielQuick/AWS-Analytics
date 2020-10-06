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
        try Amplify.add(plugin: AWSPinpointAnalyticsPlugin())

        print("Amplify added Auth and Analytics plugins")
        result(true)
    } catch {
        print("Failed to initialize Amplify with \(error)")
        result(false)
    }
  }

  func registerGlobalProperties(properties: [String:Any], result: FlutterResult) {
    var globalProperties: [String:AnalyticsPropertyValue] = [:];
    for (key, value) in properties {
        if let value = value as? String {
            globalProperties[key] = value
        } else if let value = value as? Int {
            globalProperties[key] = value
        } else if let value = value as? Double {
            globalProperties[key] = value
        } else if let value = value as? Bool {
            globalProperties[key] = value
        } else {
            print("No can do " + key);
        }
    }
    Amplify.Analytics.registerGlobalProperties(globalProperties)
    result(true)
  }

  func unregisterGlobalProperties(properties: Array<String>?, result: FlutterResult) {
    if let properties = properties {
      let objectSet = Set(properties.map { $0 })
      Amplify.Analytics.unregisterGlobalProperties(objectSet)
    } else {
      Amplify.Analytics.unregisterGlobalProperties()
    }
    result(true)
  }

  func record(eventName: String, properties: [String:Any], result: FlutterResult) {
    var preparedProperties: [String:AnalyticsPropertyValue] = [:];

    for (key, value) in properties {
        if let value = value as? String {
            preparedProperties[key] = value
        } else if let value = value as? Int {
            preparedProperties[key] = value
        } else if let value = value as? Double {
            preparedProperties[key] = value
        } else if let value = value as? Bool {
            preparedProperties[key] = value
        } else {
            print("No can do " + key);
        }
    }
    let event = BasicAnalyticsEvent(name: eventName, properties: preparedProperties)

    Amplify.Analytics.record(event: event)
    result(true)
  }
}
